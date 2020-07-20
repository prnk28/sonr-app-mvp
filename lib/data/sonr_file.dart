// ignore: avoid_web_libraries_in_flutter
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:path/path.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sonar_app/data/data.dart';
import 'package:universal_html/html.dart';
// TODO: Add after HiveDB implementation
// import 'package:sonar_app/models/models.dart';

// ** CONSTANTS **
const CHUNK_SIZE = 16000; // Maximum Transmission Unit in Bytes
const CHUNKS_PER_ACK = 64;

class SonrFile {
  // ** OBJECTS:
  FileReader _reader = new FileReader();

  // ** PROPERTIES:
  // Default Private Properties
  int _chunksTotal;
  File _file;
  DateTime _lastModified;
  String _name;
  int _size;

  // Transmission Private Properties
  bool _isComplete;
  bool _isSender;

  // Public Properties
  double sendingProgress;
  double receivingProgress;
  FileType type;

  // TODO: Add after HiveDB implementation
  // Profile sender;
  // Profile receiver;

  // ** CONSTRUCTER - Checks if File is Local**
  SonrFile(bool sending, dynamic info, {Uint8List bytes, String path}) {
    if (sending) {
      // Set Transmission Private Properties
      this._isComplete = false;
      this._isSender = true;

      // Set Default Private Properties
      this._file = new File(bytes, basename(path));
      this._name = _file.name;
      this._size = _file.size;
      this._lastModified = _file.lastModifiedDate;
      this._chunksTotal = (this._size / CHUNK_SIZE).ceil();

      // Set Public Properties
      this.receivingProgress = 0.0;
      this.sendingProgress = 0.0;
      this.type = getFileType(path);
    } else {
      // Set Transmission Properties
      this._isComplete = false;
      this._isSender = false;

      // Set Default Properties

      this._name = info._name;
      this._size = info._size;
      this._lastModified = info._lastModified;
      this._chunksTotal = info._chunksTotal;

      // Set Public Properties
      this.receivingProgress = 0.0;
      this.sendingProgress = 0.0;
      this.type = info.type;
    }
  }

  // ** BOOL: Add Chunk received from Sender
  bool addChunk(ByteBuffer block, int receivedChunkNum) {
    // Verify Receiver
    if (!_isSender) {
      // Set Variables
      int nextChunkNum = receivedChunkNum + 1;
      bool lastChunkInFile = receivedChunkNum == this._chunksTotal - 1;
      bool lastChunkInBlock =
          receivedChunkNum > 0 && (receivedChunkNum + 1) % CHUNKS_PER_ACK == 0;
    }
    throw ("Cannot Add Chunk, User is sender.");
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  void sendChunk(RTCDataChannel dc, Socket s, int beginChunkNum) {
    // Verify Sender
    if (_isSender) {
      // Set Variables
      int remainingChunks = this._chunksTotal - beginChunkNum;
      int chunksToSend = [remainingChunks, CHUNKS_PER_ACK].reduce(min);
      int endChunkNum = beginChunkNum + chunksToSend - 1;
      int blockBegin = beginChunkNum * CHUNK_SIZE;
      int blockEnd = (endChunkNum * CHUNK_SIZE) + CHUNK_SIZE;

      // Read whole block from File
      var blockBlob = this._file.slice(blockBegin, blockEnd, _file.type);

      // Utilize File Reader
      this._reader.onLoad.listen((fileEvent) {
        // Initialize Block Buffer
        File blockBuffer = new File(this._reader.result, this._name);

        // Loop Chunks
        for (int chunkNum = beginChunkNum;
            chunkNum < endChunkNum + 1;
            chunkNum++) {
          // Send Each Chunk (begin index is inclusive, end index is exclusive)
          var bufferBegin = (chunkNum % CHUNKS_PER_ACK) * CHUNK_SIZE;
          var bufferEnd =
              [bufferBegin + CHUNK_SIZE, blockBuffer.size].reduce(min);

          // Create Buffer Chunk set as Binary
          var chunkBlob = blockBuffer.slice(bufferBegin, bufferEnd, _file.type);

          // Send Binary in WebRTC Data Channel
          dc.send(RTCDataChannelMessage.fromBinary(chunkBlob as Uint8List));

          // Send Progress in WebRTC Channel
          s.emit("SEND_PROGRESS", (chunkNum + 1) / this._chunksTotal);
        }
        // Check if Complete -> Emit Socket.io
        if (endChunkNum == this._chunksTotal - 1) {
          s.emit("SEND_COMPLETE");
        }
      });

      // Read as Array Buffer
      _reader.readAsArrayBuffer(blockBlob);
    }
    throw ("Cannot Send Chunk, User is receiver.");
  }

  // ** JSON: Get Info of File **
  dynamic getFileInfo() {
    return {
      "chunksTotal": this._chunksTotal,
      "lastModified": this._lastModified,
      "name": this._name,
      "size": this._size,
      "type": this.type
    };
  }
}
