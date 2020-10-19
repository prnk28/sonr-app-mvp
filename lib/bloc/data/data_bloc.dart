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
  // Initialize Repositories
  final UserBloc user;
  BytesBuilder block = new BytesBuilder();
  RTCDataChannel dataChannel;

  // Traffic Handling Maps
  List<Metadata> incoming;
  Map<Metadata, File> outgoing;
  Tuple2<Metadata, File> currentFile;
  ProgressCubit progressCubit = new ProgressCubit();

  // Constructers
  DataBloc(this.user) : super(null) {
    // Initialize Maps
    incoming = new List<Metadata>();
    outgoing = new Map<Metadata, File>();

    // Add DataChannel
    user.node.session.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // Handle DataChannel Message
    user.node.session.onDataChannelMessage =
        (dc, RTCDataChannelMessage message) async {
      // Check if Binary
      if (message.isBinary) {
        // Add Binary to Transfer
        add(AddChunk(message.binary));
      }
      // Check if Text
      else {
        // Check for Completion Message
        if (message.text == "SEND_COMPLETE") {
          log.i("Send is Done");
          // Call Bloc Event
          add(WriteFile());
        } else {
          log.v(message.text);
        }
      }
    };
  }

  // Map Methods
  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is AddChunk) {
      yield* _mapAddChunkState(event);
    } else if (event is SendChunks) {
      yield* _mapSendChunksState(event);
    } else if (event is WriteFile) {
      yield* _mapWriteFileState(event);
    } else if (event is QueueFile) {
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
  Stream<DataState> _mapQueueFileState(QueueFile event) async* {
    // Check if Queue is Incoming
    if (event.info != null && event.file == null) {
      // Create Metadata
      var incomingMeta = new Metadata(map: event.info);

      // Add File to Incoming Tracker
      incoming.add(incomingMeta);

      // Set Current File
      currentFile = Tuple2<Metadata, File>(incomingMeta, null);

      yield Queued(currentFile);
    }

    // Check if Queue is Outgoing
    else {
      // Current Fake File
      File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

      // Create Metadata
      var outgoingMeta = new Metadata(file: dummyFile);

      // Add to Outgoing File Map
      outgoing[outgoingMeta] = dummyFile;

      // Set Current File
      currentFile = Tuple2<Metadata, File>(outgoingMeta, dummyFile);

      yield Queued(currentFile);
    }
  }

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk event) async* {
    // Add Chunk to Block
    block.add(event.chunk);

    // Get Metadata
    Metadata currMeta = currentFile.item1;

    // Update Chunks
    currMeta.currentChunkNum += 1;
    currMeta.remainingChunks = currMeta.chunksTotal - currMeta.currentChunkNum;

    // Update Progress
    progressCubit.update((currMeta.chunksTotal - currMeta.remainingChunks) /
        currMeta.chunksTotal);

    // Yield Progress
    yield Saving(file: this.currentFile);
  }

// **********************
// ** SendChunks Event **
// **********************
  Stream<DataState> _mapSendChunksState(SendChunks event) async* {
    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(currentFile.item2.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // End of List
      if (data.length <= 0) {
        // Send Complete Message on same DC
        dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

        // Update Traffic Variables
        outgoing.remove(currentFile.item1);
        currentFile = null;
        log.i("Completed Transmission");

        // Call Bloc Event
        yield Done();
        break;
      }
      // Send Current Chunk
      else {
        // Send Binary in WebRTC Data Channel
        dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

        // Get Metadata
        Metadata currMeta = currentFile.item1;

        // Update Chunks
        currMeta.currentChunkNum += 1;
        currMeta.remainingChunks =
            currMeta.chunksTotal - currMeta.currentChunkNum;

        // Update Progress
        progressCubit.update((currMeta.chunksTotal - currMeta.remainingChunks) /
            currMeta.chunksTotal);

        // Yield Progress
        yield Transmitting(file: this.currentFile);
      }
    }
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile event) async* {
    // Get App Directory
    Directory tempDir = await getTemporaryDirectory();

    // Generate File Path
    var filePath = tempDir.path + '/file_01.tmp';

    // Get Data
    Uint8List data = block.takeBytes();
    final buffer = data.buffer;

    // Save File to Disk
    File rawFile = await new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // Remove from Incoming
    incoming.removeAt(0);
    log.i("File Saved");

    // Yield Complete
    yield Done(file: Tuple2<Metadata, File>(currentFile.item1, rawFile));
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
