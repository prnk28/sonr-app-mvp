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
  // Repositories
  final UserBloc user;
  ProgressCubit progress;
  Traffic traffic;
  SonrFile currentFile;

  // Data Channel
  BytesBuilder block = new BytesBuilder();

  // Constructers
  DataBloc(this.user) : super(null) {
    // Initialize Repositories
    progress = new ProgressCubit();
    traffic = new Traffic(user.session);

    // Set Current File
    traffic.onAddFile = (file) {
      currentFile = file;
    };

    // Add Binary Chunk
    traffic.onBinaryChunk = (chunk) {
      add(PeerAddedChunk(chunk));
    };

    // On Transfer Complete
    traffic.onTransferComplete = () {
      // Write Current File
      add(PeerReceiveCompleted());
    };
  }

  // Map Methods
  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is PeerAddedChunk) {
      yield* _mapPeerAddedChunkState(event);
    } else if (event is PeerSentChunk) {
      yield* _mapPeerSentChunkState(event);
    } else if (event is PeerReceiveCompleted) {
      yield* _mapPeerReceiveCompletedState(event);
    } else if (event is UserSearchedFile) {
      yield* _mapFindFileState(event);
    } else if (event is UserOpenedFile) {
      yield* _mapOpenFileState(event);
    }
  }

// **************************
// ** PeerAddedChunk Event **
// **************************
  Stream<DataState> _mapPeerAddedChunkState(PeerAddedChunk event) async* {
    // Add Chunk to Block
    block.add(event.chunk);

    // Update Progress in Current MetaData
    currentFile.addProgress(this);

    // Check if Receive is Done
    if (currentFile.isProgressComplete()) {
      // Save File
      SonrFile file = await currentFile.save(block.takeBytes());

      // Clear incoming traffic
      traffic.clear(TrafficDirection.Incoming);

      // Yield Complete
      yield PeerReceiveComplete(file: file);
    }
    // Yield Progress
    else {
      yield PeerReceiveInProgress();
    }
  }

// *************************
// ** PeerSentChunk Event **
// *************************
  Stream<DataState> _mapPeerSentChunkState(PeerSentChunk event) async* {
    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(currentFile.file.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // End of List
      if (data.length <= 0) {
        // Complete Tranfer
        traffic.complete(currentFile);

        // Call Bloc Event
        yield PeerSendComplete();
        break;
      }
      // Send Current Chunk
      else {
        // Sends and Updates Progress
        traffic.transmit(currentFile, chunk);

        // Update Progress
        currentFile.addProgress(this);

        // Yield Progress
        yield PeerSendInProgress();
      }
    }
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapPeerReceiveCompletedState(
      PeerReceiveCompleted event) async* {}

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
