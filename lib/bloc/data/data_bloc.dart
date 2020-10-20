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
    traffic = new Traffic(this, user.node.session);
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
    } else if (event is Queue) {
      yield* _mapQueueFileState(event);
    } else if (event is FindFile) {
      yield* _mapFindFileState(event);
    } else if (event is OpenFile) {
      yield* _mapOpenFileState(event);
    }
  }

// *****************
// ** Queue Event **
// *****************
  Stream<DataState> _mapQueueFileState(Queue event) async* {
    // Check Queue Type
    switch (event.type) {
      case QueueType.IncomingFile:
        // Create SonrFile
        SonrFile file = new SonrFile(metadata: event.metadata);

        // Set Current File
        currentFile = file;

        // Add to Incoming
        traffic.addFile(TrafficDirection.Incoming, file);
        break;
      case QueueType.OutgoingFile:
        // Create SonrFile
        SonrFile file = new SonrFile(file: event.rawFile);

        // Set Current File
        currentFile = file;

        // Add to Outgoing
        traffic.addFile(TrafficDirection.Outgoing, file);
        break;
      case QueueType.Offer:
        print("Not done yet");
        break;
    }

    yield Queued(currentFile);
  }

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk event) async* {
    // Add Chunk to Block
    block.add(event.chunk);

    // Update Progress in Current MetaData
    currentFile.addProgress(this, Role.Receiver);

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
        // Send Complete Message on same DC
        user.node.complete(event.match);
        //currentFile = null;

        // Clear outgoing traffic
        traffic.clear(TrafficDirection.Outgoing);

        // Call Bloc Event
        yield Done();
        break;
      }
      // Send Current Chunk
      else {
        // Sends and Updates Progress
        traffic.transmit(currentFile, chunk);

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
