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
  List<FileTransfer> outgoing;
  List<FileTransfer> incoming;

  // Constructers
  DataBloc() : super(null) {
    // Initialize Maps
    outgoing = new List<FileTransfer>();
    incoming = new List<FileTransfer>();

    // Add DataChannel
    rtcSession.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // Handle DataChannel Message
    rtcSession.onDataChannelMessage =
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
    } else if (event is Progress) {
      yield* _mapProgressState(event);
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

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk addEvent) async* {
    // Add Chunk to Block
    block.add(addEvent.chunk);

    // Update Progress
    add(Progress());

    // Yield Progress
    yield Saving(file: incoming.first);
  }

// ********************
// ** Progress Event **
// ********************
  Stream<DataState> _mapProgressState(Progress event) async* {
    // Get File thats being sent to Peer
    // FileTransfer incomingFile = incoming.first;

    // // Update Chunks
    // incomingFile.currentChunkNum += 1;
    // incomingFile.remainingChunks =
    //     incomingFile.chunksTotal - incomingFile.currentChunkNum;

    // // Update Progress
    // double progress =
    //     (incomingFile.chunksTotal - incomingFile.remainingChunks) /
    //         incomingFile.chunksTotal;

    //Log Progress
    log.i("Receiving Chunk");

    //Yield Progress
    yield Updating();
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

      // End of List
      if (data.length <= 0) {
        // Send Complete Message on same DC
        dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

        // Remove from Outgoing
        log.i("Completed Transfer");
        outgoing.removeAt(0);

        // Call Bloc Event
        yield Done();
        break;
      }
      // Send Current Chunk
      else {
        // Send Binary in WebRTC Data Channel
        dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));
        log.i("Sent Chunk");

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

        // Log Progress
        log.i("Send Progress: " + (progress * 100).toString() + "%");

        // Yield Progress
        yield Transmitting(file: outgoingFile, progress: progress);
      }
    }
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile writeEvent) async* {
    // Get File thats being sent to Peer
    // FileTransfer incomingFile = incoming.first;
    // log.i(incomingFile.name);

    // Get App Directory
    Directory tempDir = await getTemporaryDirectory();

    // Generate File Path
    var filePath = tempDir.path + '/file_01.tmp';

    // Save File to Disk
    File rawFile = await writeToFile(block.takeBytes(), filePath);

    // Create MetaData
    // Metadata meta = new Metadata();
    // meta.name = incomingFile.name;
    // meta.size = incomingFile.size;
    // meta.type = incomingFile.type.toString();
    // meta.path = filePath;
    // meta.received = DateTime.now();

    // // Save File Metadata
    // localData.addFileMetadata(meta, incomingFile.type);

    // Remove from Incoming
    incoming.removeAt(0);

    log.i("File Saved");

    // Yield Complete
    yield Done(rawFile: rawFile);
  }

// **********************
// ** QueueFile Event **
// **********************
  Stream<DataState> _mapQueueFileState(QueueFile queueEvent) async* {
    if (queueEvent.receiving) {
      // Create File Object
      var incomingFile = new FileTransfer();

      // Set File to Incoming Tracker
      incoming.add(incomingFile);
      log.i("File added to incoming");
    } else {
      // Create File Object
      var outgoingFile = new FileTransfer(localFile: queueEvent.file);

      // Set File to Outgoing Tracker
      outgoing.add(outgoingFile);
      log.i("File added to outgoing");
      yield Selected();
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
