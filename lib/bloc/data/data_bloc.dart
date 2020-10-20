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
    traffic = new Traffic(user.node.session);

    // Set Current File
    traffic.onAddFile = (file) {
      currentFile = file;
    };

    // Add Binary Chunk
    traffic.onBinaryChunk = (chunk) {
      add(AddChunk(chunk));
    };

    // On Transfer Complete
    traffic.onTransferComplete = () {
      // Write Current File
      add(WriteFile());
    };
  }

  // Map Methods
  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is AddChunk) {
      yield* _mapAddChunkState(event);
    } else if (event is Transfer) {
      yield* _mapTransferState(event);
    } else if (event is WriteFile) {
      yield* _mapWriteFileState(event);
    } else if (event is FindFile) {
      yield* _mapFindFileState(event);
    } else if (event is OpenFile) {
      yield* _mapOpenFileState(event);
    }
  }

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk event) async* {
    // Add Chunk to Block
    block.add(event.chunk);

    // Update Progress in Current MetaData
    currentFile.addProgress(this);

    // Yield Progress
    yield Receiving();
  }

// ********************
// ** Transfer Event **
// ********************
  Stream<DataState> _mapTransferState(Transfer event) async* {
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
        yield Done();
        break;
      }
      // Send Current Chunk
      else {
        // Sends and Updates Progress
        traffic.transmit(currentFile, chunk);

        // Update Progress
        currentFile.addProgress(this);

        // Yield Progress
        yield Sending();
      }
    }
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile event) async* {
    // Get FilePath
    Directory tempDir = await getTemporaryDirectory();
    var filePath = tempDir.path + '/file_01.tmp';

    // Save File
    SonrFile file = await currentFile.save(block.takeBytes(), filePath);

    // Clear incoming traffic
    traffic.clear(TrafficDirection.Incoming);

    // Yield Complete
    yield Done(file: file);
  }

// ********************
// ** FindFile Event **
// ********************
  Stream<DataState> _mapFindFileState(FindFile event) async* {
    // Check Status
  }

// ********************
// ** OpenFile Event **
// ********************
  Stream<DataState> _mapOpenFileState(OpenFile event) async* {}
}
