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
  BytesBuilder block = new BytesBuilder();
  RTCDataChannel dataChannel;

  // Traffic Handling Maps
  List<FileTransfer> outgoing = List<FileTransfer>();
  List<FileTransfer> incoming = List<FileTransfer>();

  // Constructers
  DataBloc() : super(null) {
    // Add DataChannel
    rtcSession.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // Handle DataChannel Message
    rtcSession.onDataChannelMessage =
        (dc, RTCDataChannelMessage message) async {
      // Get File Reference
      var transfer = incoming.first;

      // Check if Binary
      if (message.isBinary) {
        // Add Binary to Transfer
        add(AddChunk(message.binary));
      }
      // Check if Text
      else {
        // Check for Completion Message
        if (message.text == "SEND_COMPLETE") {
          // Call Bloc Event
          //add(WriteFile(file));
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
    } else if (event is UpdateProgress) {
      yield* _mapUpdateProgressState(event);
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

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk add) async* {
    // Get File thats being sent to Peer
    FileTransfer incomingFile = incoming.first;

    // Add Chunk to Block
    block.add(add.chunk);

    // Update Chunks
    incomingFile.currentChunkNum += 1;
    incomingFile.remainingChunks =
        incomingFile.chunksTotal - incomingFile.currentChunkNum;

    // Update Progress
    double progress =
        (incomingFile.chunksTotal - incomingFile.remainingChunks) /
            incomingFile.chunksTotal;

    // Log Progress
    log.i("Receive Progress: " + (progress * 100).toString() + "%");

    // Yield Progress
    yield Saving(file: incomingFile, progress: progress);
  }

// **********************
// ** SendChunks Event **
// **********************
  Stream<DataState> _mapSendChunksState(SendChunks sendChunkEvent) async* {
    // Get File thats being sent to Peer
    FileTransfer transfer = outgoing.first;

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(transfer.file.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Update Chunk Info
      add(UpdateProgress());

      // Send Binary in WebRTC Data Channel
      dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

      // Yield Updating
      yield Updating();

      // End of List
      if (data.length <= 0) {
        // Send Complete Message on same DC
        dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

        // Remove from Outgoing
        outgoing.removeAt(0);

        // Call Bloc Event
        yield Done();
      }
      print('next byte: ${data[0]}');
    }
  }

// **************************
// ** UpdateProgress Event **
// **************************
  Stream<DataState> _mapUpdateProgressState(UpdateProgress updateEvent) async* {
    // Get File thats being sent to Peer
    FileTransfer outgoingFile = outgoing.first;

    // Set Variables
    outgoingFile.currentChunkNum = outgoingFile.currentChunkNum += 1;
    outgoingFile.remainingChunks =
        outgoingFile.chunksTotal - outgoingFile.currentChunkNum;

    // Update Progress
    double progress =
        (outgoingFile.chunksTotal - outgoingFile.remainingChunks) /
            outgoingFile.chunksTotal;

    // Yield Progress
    yield Transferring(file: outgoingFile, progress: progress);
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile writeEvent) async* {
    // Get File thats being sent to Peer
    FileTransfer incomingFile = incoming.first;

    // Convert Uint8List to File
    Uint8List data = block.takeBytes();

    // Get App Directory
    Directory tempDir = await getApplicationDocumentsDirectory();

    // Generate File Path
    String filePath =
        tempDir.path + incomingFile.type.toString() + incomingFile.name;

    // Save File at Path
    File rawFile = await new File(filePath).writeAsBytes(data);

    // Create MetaData
    Metadata meta = new Metadata();
    meta.name = incomingFile.name;
    meta.size = incomingFile.size;
    meta.type = incomingFile.type.toString();
    meta.path = filePath;
    meta.received = DateTime.now();

    // Save File Metadata
    localData.addFileMetadata(meta, incomingFile.type);

    // Remove from Incoming
    incoming.removeAt(0);

    // Yield Complete
    yield Done(rawFile: rawFile, metadata: meta);
  }

// **********************
// ** QueueFile Event **
// **********************
  Stream<DataState> _mapQueueFileState(QueueFile queueEvent) async* {
    // TODO: Get Dummy Asset File -- Temporary
    File transferToSend =
        await localData.getAssetFileByPath("assets/images/fat_test.jpg");

    if (queueEvent.receiving) {
      // Create File Object
      var incomingFile = new FileTransfer(info: queueEvent.info);

      // Set File to Incoming Tracker
      incoming.add(incomingFile);
    } else {
      // Create File Object
      var outgoingFile = new FileTransfer(localFile: transferToSend);

      // Set File to Outgoing Tracker
      outgoing.add(outgoingFile);
    }
  }

// ********************
// ** FindFile Event **
// ********************
  Stream<DataState> _mapFindFileState(FindFile findFileEvent) async* {
    // Check Status
  }

// ********************
// ** OpenFile Event **
// ********************
  Stream<DataState> _mapOpenFileState(OpenFile openFileEvent) async* {
    // Check Status
  }
}
