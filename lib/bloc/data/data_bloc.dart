import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  // Subscription
  StreamSubscription _userSub;
  RTCSession _session;
  RTCDataChannel _dataChannel;
  ProgressCubit progress;

  // Traffic Maps - MatchId/File
  List<SonrFile> _incoming;
  List<SonrFile> _outgoing;
  SonrFile currentFile;

  // References
  final UserBloc user;

  // Constructers
  DataBloc(this.user) : super(null) {
    // ** Initialization ** //
    // Traffic Maps
    _incoming = new List<SonrFile>();
    _outgoing = new List<SonrFile>();
    _session = user.session;

    // Progress
    progress = new ProgressCubit();

    // ** Data BLoC Subscription ** //
    _userSub = user.listen((UserState state) {
      // Queue Incoming Transfer
      if (state is NodeTransferInitial) {
        add(PeerQueuedFile(TrafficDirection.Incoming,
            metadata: state.metadata));
      }
      // Begin Transfer
      else if (state is NodeTransferInProgress) {
        // Send Chunk
        add(PeerSendingChunk());
      }
    });

    // ** RTCSession Subscription ** //
    _session.onDataChannel = (channel) {
      // Check Channel Status
      _dataChannel = channel;
    };

    // Handle DataChannel Message
    _session.onDataChannelMessage = (dc, RTCDataChannelMessage message) async {
      // Check if Binary
      if (message.isBinary) {
        add(PeerAddedChunk(message.binary));
      }
      // Check if Text
      else {
        // Check for Completion Message
        if (message.text == "NEXT_CHUNK") {
          add(PeerSendingChunk());
        }
      }
    };
  }

  // On Bloc Close
  void dispose() {
    _userSub.cancel();
  }

  // Map Methods
  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is PeerQueuedFile) {
      yield* _mapPeerQueuedFileState(event);
    } else if (event is PeerClearedQueue) {
      yield* _mapPeerClearedQueueState(event);
    } else if (event is PeerAddedChunk) {
      yield* _mapPeerAddedChunkState(event);
    } else if (event is PeerSendingChunk) {
      yield* _mapPeerSentChunkState(event);
    } else if (event is UserSearchedFile) {
      yield* _mapFindFileState(event);
    } else if (event is UserOpenedFile) {
      yield* _mapOpenFileState(event);
    }
  }

// **************************
// ** PeerQueuedFile Event **
// **************************
  Stream<DataState> _mapPeerQueuedFileState(PeerQueuedFile event) async* {
    // Queue by direction
    switch (event.direction) {
      case TrafficDirection.Incoming:
        // Create SonrFile
        SonrFile file = new SonrFile(event.sender, metadata: event.metadata);

        // Add To Incoming
        _incoming.add(file);

        // Set Current
        currentFile = file;
        break;
      case TrafficDirection.Outgoing:
        // Create SonrFile
        SonrFile file = new SonrFile(user.node, file: event.rawFile);

        // Add to Outgoing
        _outgoing.add(file);

        // Set Current
        currentFile = file;
        break;
    }
  }

// **************************
// ** PeerAddedChunk Event **
// **************************
  Stream<DataState> _mapPeerAddedChunkState(PeerAddedChunk event) async* {
    // Check if Receive is Done
    if (currentFile.isComplete()) {
      // Tell Sender Complete
      _dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

      // Save File
      SonrFile file = await currentFile.save();

      // Clear incoming traffic
      add(PeerClearedQueue(TrafficDirection.Incoming));

      // Yield Complete
      user.add(NodeCompleted(file.owner, file: file));

      // Change State
      yield PeerReady();
    }
    // Yield Progress
    else {
      // Add Chunk to SonrFile
      double currProgress = currentFile.addChunk(event.chunk);

      // Check if Complete
      if (currentFile.remainingChunks > 0) {
        // Request next chunk
        _dataChannel.send(RTCDataChannelMessage("NEXT_CHUNK"));
      }

      // Update Progress
      progress.update(currProgress);

      // Change State
      yield PeerReceiveInProgress();
    }
  }

// *************************
// ** PeerSentChunk Event **
// *************************
  Stream<DataState> _mapPeerSentChunkState(PeerSendingChunk event) async* {
    // End of List
    if (currentFile.isComplete()) {
      // Call Bloc Event
      user.add(NodeCompleted(currentFile.owner));

      // TODO: Complete Tranfer end Session

      // Change State
      yield PeerReady();
    }
    // Send Current Chunk
    else {
      // Sends and Updates Progress
      var currProgress = await currentFile.sendChunk(_dataChannel);

      // Update Progress
      progress.update(currProgress);

      // Yield Progress
      yield PeerSendInProgress();
    }
  }

// **************************
// ** PeerClearedQueue Event **
// **************************
  Stream<DataState> _mapPeerClearedQueueState(PeerClearedQueue event) async* {
    // Clear by Direction
    switch (event.direction) {
      case TrafficDirection.Incoming:
        // Clear All
        if (event.matchId == null) {
          _incoming.clear();

          // Clear Current File
          currentFile = null;
        }

        // Clear One
        _incoming.remove(event.matchId);
        break;
      case TrafficDirection.Outgoing:
        // Clear All
        if (event.matchId == null) {
          _outgoing.clear();

          // Clear Current File
          currentFile = null;
        }

        // Clear One
        _outgoing.remove(event.matchId);
        break;
    }
  }

// ********************
// ** FindFile Event **
// ********************
  Stream<DataState> _mapFindFileState(UserSearchedFile event) async* {
    // Check Status
  }

// ********************
// ** OpenFile Event **
// ********************
  Stream<DataState> _mapOpenFileState(UserOpenedFile event) async* {}
}
