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

  // Data Channel
  BytesBuilder block = new BytesBuilder();

  // Constructers
  DataBloc(this.user) : super(null) {
    // Initialize Repositories
    progress = new ProgressCubit();
    traffic = new Traffic(this, user.node.session);

    // Add DataChannel
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

// **********************
// ** QueueFile Event **
// **********************
  Stream<DataState> _mapQueueFileState(Queue event) async* {
    // Check Queue Type
    switch (event.type) {
      case QueueType.IncomingFile:
        // Add to Incoming
        traffic.addFile(TrafficDirection.Incoming,
            match: event.match, info: event.info);

        // Set as Queued
        yield Queued(traffic.current);
        break;
      case QueueType.OutgoingFile:
        // Current Fake File
        File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

        // Create Metadata
        traffic.addFile(TrafficDirection.Outgoing,
            match: event.match, file: dummyFile);

        yield Queued(traffic.current);
        break;
      case QueueType.Offer:
        print("Not done yet");
        break;
    }
  }

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk event) async* {
    // Add Chunk to Block
    block.add(event.chunk);

    // Update Progress in Current MetaData
    progress.update(traffic.current.progress());

    // Yield Progress
    yield Receiving();
  }

// ********************
// ** Transfer Event **
// ********************
  Stream<DataState> _mapTransferState(Transfer event) async* {
    // Check if DataChannel is Open
    if (traffic.isChannelActive) {
      // Open File in Reader and Send Data pieces as chunks
      final reader = ChunkedStreamIterator(traffic.current.readFile());

      // While the reader has a next byte
      while (true) {
        // read one CHUNK
        var data = await reader.read(CHUNK_SIZE);
        var chunk = Uint8List.fromList(data);

        // End of List
        if (data.length <= 0) {
          // Send Complete Message on same DC
          user.node.complete(event.match, traffic.current);

          // Clear outgoing traffic
          traffic.clear(TrafficDirection.Outgoing);

          // Call Bloc Event
          yield Done();
          break;
        }
        // Send Current Chunk
        else {
          // Sends and Updates Progress
          traffic.transmit(chunk);

          // Yield Progress
          yield Sending();
        }
      }
    }
    // Logging
    log.e("Data Channel is not open");
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile event) async* {
    // Get FilePath
    Directory tempDir = await getTemporaryDirectory();
    var filePath = tempDir.path + '/file_01.tmp';

    // Generate SonrFile
    SonrFile file = await SonrFile.fromBytes(block.takeBytes(), filePath);

    // Log
    log.i(file.metadata.name + " saved");

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
  Stream<DataState> _mapOpenFileState(OpenFile event) async* {
    await event.meta.getBytes();
  }
}
