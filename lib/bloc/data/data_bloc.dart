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
  Node _match;

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

    // ** User BLoC Subscription ** //
    _userSub = user.listen((UserState state) {
      // Queue Incoming Transfer
      if (state is NodeTransferInitial) {
        add(PeerQueuedFile(TrafficDirection.Incoming,
            metadata: state.metadata, sender: state.match));
      }
    });

    // ** RTCSession Subscription ** //
    _session.onDataChannel = (channel) {
      // Check Channel Status
      _dataChannel = channel;
    };

    _session.onDataChannelState = (channel, e) {
      // Begin Transfer
      if (e == RTCDataChannelState.RTCDataChannelOpen) {
        // Send Chunk
        add(PeerSendingChunk());
      }
    };

    // Handle DataChannel Message
    _session.onDataChannelMessage = (dc, RTCDataChannelMessage message) async {
      // Check if Binary
      if (message.isBinary) {
        add(PeerAddedChunk(message.binary));
      } else {
        if (message.text == "SEND_COMPLETE") {
          user.add(NodeCompleted());
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
        // Get Dummy RawFile
        File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

        // Create SonrFile
        SonrFile file = new SonrFile(user.node, file: dummyFile);

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
    // Add Chunk to SonrFile
    currentFile.addChunk(event.chunk);

    // Update Progress
    var currProgress = currentFile.progress();

    // Check if Receive is Done
    if (currentFile.isComplete()) {
      // Tell Sender Complete
      _dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

      // Save File
      await currentFile.save();

      // Yield Complete
      user.add(NodeCompleted(file: currentFile));
    } else {
      progress.update(currProgress);
      yield PeerReceiveInProgress();
    }
  }

// *************************
// ** PeerSentChunk Event **
// *************************
  Stream<DataState> _mapPeerSentChunkState(PeerSendingChunk event) async* {
    // Open Reader with Offset
    final reader = ChunkedStreamIterator(currentFile.file.openRead());

    // While Reader Has Values
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Send Current Chunk
      if (data.length > 0) {
        // Sends and Updates Progress
        _dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

        // Update Progress
        progress.update(currentFile.progress());

        // Yield Progress
        yield PeerSendInProgress();
      }
      // End of List
      else {
        break;
      }
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
