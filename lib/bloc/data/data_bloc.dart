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
          // Change user State
          user.add(NodeCompleted());

          // Clear Outgoing
          add(PeerClearedQueue(TrafficDirection.Outgoing));
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
    } else if (event is FileQueuedComplete) {
      yield* _mapFileQueuedCompleteState(event);
    } else if (event is PeerClearedQueue) {
      yield* _mapPeerClearedQueueState(event);
    } else if (event is PeerAddedChunk) {
      yield* _mapPeerAddedChunkState(event);
    } else if (event is PeerSendingChunk) {
      yield* _mapPeerSentChunkState(event);
    } else if (event is UserSearchedFile) {
      yield* _mapFindFileState(event);
    } else if (event is UserGetAllFiles) {
      yield* _mapUserGetAllFilesState(event);
    } else if (event is UserGetFile) {
      yield* _mapUserGetFileState(event);
    } else if (event is UserLoadFile) {
      yield* _mapUserLoadFileState(event);
    } else if (event is UserDeleteFile) {
      yield* _mapUserDeleteFileState(event);
    }
  }

// **************************
// ** PeerQueuedFile Event **
// **************************
  Stream<DataState> _mapPeerQueuedFileState(PeerQueuedFile event) async* {
    // Queue by direction
    if (event.direction == TrafficDirection.Incoming) {
      // Create SonrFile
      SonrFile file = new SonrFile(event.sender, metadata: event.metadata);

      // Add To Incoming
      _incoming.add(file);

      // Set Current
      currentFile = file;

      // Inform Bloc Queue is Complete
      add(FileQueuedComplete());

      // Change State
      yield PeerQueueInProgress();
    } else {
      // Get Dummy RawFile
      File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

      // Create SonrFile
      SonrFile file = new SonrFile(user.node, raw: dummyFile);

      // Add to Outgoing
      _outgoing.add(file);

      // Set Current
      currentFile = file;

      // Inform Bloc Queue is Complete
      add(FileQueuedComplete());

      // Change State
      yield PeerQueueInProgress();
    }
  }

// ******************************
// ** FileQueuedComplete Event **
// ******************************
  Stream<DataState> _mapFileQueuedCompleteState(
      FileQueuedComplete event) async* {
    // Check for Raw File
    if (currentFile.raw != null) {
      // Set File Preview
      await currentFile.setPreview();
    }
    yield PeerQueueSuccess();
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

      // Clear Incoming
      add(PeerClearedQueue(TrafficDirection.Incoming));
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
    final reader = ChunkedStreamIterator(currentFile.raw.openRead());

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
    if (event.direction == TrafficDirection.Incoming) {
      // Clear All
      if (event.matchId == null) {
        _incoming.clear();

        // Clear Current File
        currentFile = null;
      }

      // Clear One
      _incoming.remove(event.matchId);
    } else {
      // Clear All
      if (event.matchId == null) {
        _outgoing.clear();

        // Clear Current File
        currentFile = null;
      }

      // Clear One
      _outgoing.remove(event.matchId);
    }
    yield PeerInitial();
  }

// ****************************
// ** UserSearchedFile Event **
// ****************************
  Stream<DataState> _mapFindFileState(UserSearchedFile event) async* {
    // Check Status
  }

// ***************************
// ** UserGetAllFiles Event **
// ***************************
  Stream<DataState> _mapUserGetAllFilesState(UserGetAllFiles event) async* {
    // Open Provider
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();

    // Get All Files
    List<Metadata> allFiles = await metadataProvider.getAllFiles();

    // Change State
    if (allFiles != null) {
      yield UserLoadedFilesSuccess(allFiles);
    } else {
      yield UserLoadedFilesFailure();
    }
  }

// ***********************
// ** UserGetFile Event **
// ***********************
  Stream<DataState> _mapUserGetFileState(UserGetFile event) async* {
    // Initialize
    SonrFile file;

    // Check if File ID provided
    if (event.fileId != null && event.meta == null) {
      // Open Provider
      MetadataProvider metadataProvider = new MetadataProvider();
      await metadataProvider.open();

      // Get File
      Metadata metadata = await metadataProvider.getFile(event.fileId);
      file = SonrFile.fromSaved(metadata);
    }
    // Check if Metadata provided
    else if (event.meta != null && event.fileId == null) {
      // Get Data
      file = SonrFile.fromSaved(event.meta);
    }
    // Change State
    add(UserLoadFile(file));

    // Change state
    yield UserViewingFileInProgress(file.metadata);
  }

// ************************
// ** UserLoadFile Event **
// ************************
  Stream<DataState> _mapUserLoadFileState(UserLoadFile event) async* {
    // Get Bytes
    Uint8List bytes = await event.file.raw.readAsBytes();

    // Change State
    yield UserViewingFileSuccess(bytes, event.file.metadata);
  }

  // ************************
// ** UserDeleteFile Event **
// ************************
  Stream<DataState> _mapUserDeleteFileState(UserDeleteFile event) async* {
    // Get Provider
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();

    // Remove From Database
    int count = await metadataProvider.delete(event.meta.id);
    log.i(count.toString() + "Files Removed from database");

    // Remove from LocalData
    var ref = File(event.meta.path);
    await ref.delete();

    // Reload Files
    add(UserGetAllFiles());

    yield UserDeletedFileSuccess();
  }
}
