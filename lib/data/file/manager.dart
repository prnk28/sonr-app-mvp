import 'dart:io';
import 'package:flutter_webrtc/rtc_data_channel.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';

class FileManager {
  // Initialization
  Session session;
  SonarBloc bloc;
  RTCDataChannel dataChannel;

  // Constructor
  FileManager(this.bloc, this.session) {
    session.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // ** RTC::Data Message **
    session.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      if (data.isBinary) {
        log.i("Received Chunk");
      }
    };
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  Future<void> sendBlock(int beginChunkNum) async {
    // Set Variables
    //int remainingChunks = this._chunksTotal - beginChunkNum;
    //int chunksToSend = [remainingChunks, CHUNKS_PER_ACK].reduce(min);
    //int endChunkNum = beginChunkNum + chunksToSend - 1;
    //int blockBegin = beginChunkNum * CHUNK_SIZE;
    // int blockEnd = (endChunkNum * CHUNK_SIZE) + CHUNK_SIZE;

    // Get Asset File
    File file = await getAssetFileByPath("assets/images/headers/4.jpg");

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(file.openRead());
    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Send Binary in WebRTC Data Channel
      dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

      // End of List
      if (data.length <= 0) {
        socket.emit("SEND_COMPLETE");
        //_isComplete = true;
        bloc.add(Completed(null, null));
        break;
      }
      print('next byte: ${data[0]}');
    }
  }

  // ** BOOL: Add Chunk received from Sender
  bool addBlock(ByteBuffer chunk, int receivedChunkNum) {
    // Verify Receiver
    // Set Variables
    // int nextChunkNum = receivedChunkNum + 1;
    // bool lastChunkInFile = receivedChunkNum == this._chunksTotal - 1;
    // bool lastChunkInBlock =
    //     receivedChunkNum > 0 && (receivedChunkNum + 1) % CHUNKS_PER_ACK == 0;
    // receivedChunkNum = receivedChunkNum + 1;

    // // Add Chunk to Block
    // _block.addAll(chunk.asInt8List());

    // // Append the File
    // if (lastChunkInFile || lastChunkInBlock) {
    //   _fileLocal.writeAsBytes(_block).then((value) => {
    //         if (lastChunkInFile)
    //           {_isComplete = true}
    //         else
    //           {
    //             socket.emit("BLOCK_REQUEST", [peerId, nextChunkNum])
    //           }
    //       });
    // }

    throw ("Cannot Add Chunk, User is sender.");
  }
}
