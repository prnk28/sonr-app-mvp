import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'data_event.dart';
part 'data_state.dart';
part 'data_transfer.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  // Subscription
  TransferFile currentFile;
  RTCDataChannel _dataChannel;
  RTCSession _session;
  StreamSubscription _userSub;

  // Traffic Maps - MatchId/File
  List<Metadata> _incoming;
  List<Metadata> _outgoing;

  // References
  final UserBloc user;
  Node _receiver;
  Node _sender;

  // Constructers
  DataBloc(this.user) : super(null) {
    // ** Initialization ** //
    // Traffic Maps
    _incoming = new List<Metadata>();
    _outgoing = new List<Metadata>();
    _session = user.session;

    // ** User BLoC Subscription ** //
    _userSub = user.listen((UserState state) async {
      // Queue Incoming Transfer
      if (state is NodeReceiveInitial) {
        // Reference Sender and Receiver
        _sender = state.match;
        _receiver = user.node;

        // Queue Incoming File
        add(UserQueuedFile(TrafficDirection.Incoming,
            metadata: state.metadata, sender: _sender));
      }
      // Begin Outgoing Transfer
      else if (state is NodeTransferInitial) {
        // Reference Sender and Receiver
        _sender = user.node;
        _receiver = state.match;

        // Send First Block
        await currentFile.sendBlock(_dataChannel);

        // Change User State
        user.add(NodeTransmitted(_receiver));
      }
    });

    // ** RTCSession Subscription ** //
    _session.onDataChannel = (channel) {
      // Check Channel Status
      _dataChannel = channel;
    };

    // Handle DataChannel Message
    _session.onDataChannelMessage = (dc, RTCDataChannelMessage message) async {
      // ** Binary Message ** //
      if (message.isBinary) {
        // Add chunk to currentFile
        await currentFile.addChunk(message.binary);

        // Check if Block Complete
        if (currentFile.isBlockComplete) {
          // Save Block
          currentFile.saveBlock();

          // Request Sender next block
          _dataChannel.send(RTCDataChannelMessage("NEXT_BLOCK"));
        }

        // Check if File Complete
        if (currentFile.isTransferComplete) {
          add(UserReceivedFile(currentFile.metadata));
        }
      }
      // ** Text Message ** //
      else {
        // Send Chunk
        if (message.text == "NEXT_BLOCK") {
          // Send Block
          await currentFile.sendBlock(_dataChannel);

          // Sending Finished
        } else if (message.text == "SEND_COMPLETE") {
          // Clear Outgoing
          add(FileQueueCleared(TrafficDirection.Outgoing));
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
    if (event is UserQueuedFile) {
      yield* _mapUserQueuedFileState(event);
    } else if (event is FileQueuedComplete) {
      yield* _mapFileQueuedCompleteState(event);
    } else if (event is FileQueueCleared) {
      yield* _mapPeerClearedQueueState(event);
    } else if (event is UserReceivedFile) {
      yield* _mapUserReceivedFileState(event);
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
// ** UserQueuedFile Event **
// **************************
  Stream<DataState> _mapUserQueuedFileState(UserQueuedFile event) async* {
    // Queue by direction
    if (event.direction == TrafficDirection.Incoming) {
      // Add Metadata To Incoming
      _incoming.add(event.metadata);

      // Initialize File
      await event.metadata.createFile();

      // Create TransferFile
      currentFile = new TransferFile(event.metadata);

      // Inform Bloc Queue is Complete
      add(FileQueuedComplete(Role.Receiver, event.metadata));

      // Change State
      yield PeerQueueInProgress();
    } else {
      // Create SonrFile
      Metadata metadata;

      // File not Provided
      if (event.rawFile == null) {
        // Get Dummy RawFile
        File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

        // Create Metadata
        metadata = new Metadata(user.node, dummyFile);
      }
      // File Provided
      else {
        // Set SonrFile
        metadata = new Metadata(user.node, event.rawFile);
      }

      // Initialize Thumbnail
      await metadata.createThumbnail();

      // Add to Outgoing
      _outgoing.add(metadata);

      // Create TransferFile
      currentFile = new TransferFile(metadata);

      // Inform Bloc Queue is Complete
      add(FileQueuedComplete(Role.Sender, metadata));

      // Change State
      yield PeerQueueInProgress();
    }
  }

// ******************************
// ** FileQueuedComplete Event **
// ******************************
  Stream<DataState> _mapFileQueuedCompleteState(
      FileQueuedComplete event) async* {
    // Check for Raw File: Sender Queued
    if (event.role == Role.Sender) {
      // Set CurrentFileCubit
      bool status = await currentFile.initialize(Role.Sender);

      // Change State
      if (status) {
        // Change State
        yield PeerQueueSuccess(event.metadata, File(event.metadata.path));
      }
    }
    // Receiver has queued
    else {
      // Set CurrentFileCubit
      bool status = await currentFile.initialize(Role.Receiver);

      // Change State
      if (status) {
        // Return Current File
        user.add(NodeReceived(currentFile.metadata));
      }
    }
  }

// ****************************
// ** UserReceivedFile Event **
// ****************************
  Stream<DataState> _mapUserReceivedFileState(UserReceivedFile event) async* {
    // Notify Sender
    _dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

    // Yield Complete
    user.add(NodeCompleted(
        file: new File(event.metadata.path), metadata: event.metadata));

    // Save File
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();
    await metadataProvider.insert(event.metadata);

    // Clear Incoming
    add(FileQueueCleared(TrafficDirection.Incoming));
  }

// **************************
// ** PeerClearedQueue Event **
// **************************
  Stream<DataState> _mapPeerClearedQueueState(FileQueueCleared event) async* {
    // Clear by Direction
    if (event.direction == TrafficDirection.Incoming) {
      // Clear All
      if (event.matchId == null) {
        _incoming.clear();
      }
      // Clear Current File
      currentFile = null;

      // Clear One
      _incoming.remove(event.matchId);
    } else {
      // Clear All
      if (event.matchId == null) {
        _outgoing.clear();
      }

      // Clear One
      _outgoing.remove(event.matchId);

      // Clear Current File
      currentFile = null;

      // Change user State
      user.add(NodeCompleted(receiver: _receiver));
    }
    // Reset Sender/Receiver
    _sender = null;
    _receiver = null;

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
    File file;
    Metadata metadata;

    // Check if File ID provided
    if (event.fileId != null && event.meta == null) {
      // Open Provider
      MetadataProvider metadataProvider = new MetadataProvider();
      await metadataProvider.open();

      // Get File
      metadata = await metadataProvider.getFile(event.fileId);
      file = File(metadata.path);
    }
    // Check if Metadata provided
    else if (event.meta != null && event.fileId == null) {
      // Get Data
      metadata = event.meta;
      file = File(event.meta.path);
    }
    // Change State
    add(UserLoadFile(file, metadata));

    // Change state
    yield UserViewingFileInProgress(metadata);
  }

// ************************
// ** UserLoadFile Event **
// ************************
  Stream<DataState> _mapUserLoadFileState(UserLoadFile event) async* {
    // Get Bytes from SonrFile
    Uint8List bytes = await event.file.getBytes();

    // Check Bytes
    if (bytes != null) {
      // Change State
      yield UserViewingFileSuccess(bytes, event.metadata);
    } else {
      // Send Failure
      yield UserViewingFileFailure(event.metadata);
    }
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

    // Check if Path exists
    bool exists = await Directory(event.meta.path).exists();

    // File Exists
    if (exists) {
      // Remove from LocalData
      var ref = File(event.meta.path);
      await ref.delete();
    }

    // Reload Files
    add(UserGetAllFiles());

    yield UserDeletedFileSuccess();
  }
}
