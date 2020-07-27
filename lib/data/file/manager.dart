import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/repo/repo.dart';

class FileManager {
  // Initialization
  Session session;
  SonarBloc bloc;
  RTCDataChannel dataChannel;

  // Maps to Track Transfer
  var _outgoing;
  var _incoming;

  // Constructor
  FileManager(this.bloc, this.session) {
    // Initialize Maps
    _outgoing = new Map<String, TransferFile>();
    _incoming = new Map<String, TransferFile>();




  }

  // ** VOID: Adds File Metadata to Manager
  addTransferFile({dynamic info, File file}) {
    if (bloc.device.status == SonarStatus.RECEIVER) {
      // Create File Object
      var incomingFile = new TransferFile(info: info);

      // Set File to Incoming Tracker
      _incoming[bloc.session.peerId()] = incomingFile;
    } else if (bloc.device.status == SonarStatus.SENDER) {
      // Create File Object
      var outgoingFile = new TransferFile(localFile: file);

      // Set File to Outgoing Tracker
      _outgoing[bloc.session.peerId()] = outgoingFile;
    } else {
      log.e("User not in either position");
    }
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  send() async {
    // Get File thats being sent to Peer
    TransferFile transfer = _outgoing[bloc.session.peerId()];

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(transfer.file.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);
      var chunkInfo = transfer.setChunkInfo();

      // Send ChunkInfo over Channel

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
  bool addChunk(ByteBuffer chunk, int receivedChunkNum) {
    // Verify Receiver
    // // Set Variables
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
