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
  var outgoing;
  var incoming;

  // Constructor
  FileManager(this.bloc, this.session) {
    // Initialize Maps
    outgoing = new Map<String, TransferFile>();
    incoming = new Map<String, TransferFile>();

    // Add DataChannel
    session.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // Handle DataChannel Message
    session.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      this.handleMessage(data);
    };
  }

  // ** VOID: Adds File Metadata to Manager
  void queueFile(bool receiving, {dynamic info, File file}) {
    if (receiving) {
      // Create File Object
      var incomingFile = new TransferFile(info: info);

      // Set File to Incoming Tracker
      incoming[session.peerId] = incomingFile;
    } else {
      // Create File Object
      var outgoingFile = new TransferFile(localFile: file);

      // Set File to Outgoing Tracker
      outgoing[session.peerId] = outgoingFile;
    }
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  send() async {
    // Get File thats being sent to Peer
    TransferFile transfer = outgoing[session.peerId];

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(transfer.file.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Update Chunk Info
      transfer.updateChunkInfo();

      // Send Binary in WebRTC Data Channel
      dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

      // End of List
      if (data.length <= 0) {
        // Send Complete Message on same DC
        dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

        // Remove from Outgoing
        outgoing.remove(session.peerId);

        // Call Bloc Event
        bloc.add(Completed(null, null));
        break;
      }
      print('next byte: ${data[0]}');
    }
  }

  // Interpret WebRTC Message
  handleMessage(RTCDataChannelMessage message) async {
    // Get File Reference
    var transfer = this.incoming[session.peerId];

    // Check if Binary
    if (message.isBinary) {
      // Add Binary to Transfer
      transfer.addChunk(message.binary);
    }
    // Check if Text
    else {
      // Check for Completion Message
      if (message.text == "SEND_COMPLETE") {
        // Convert Uint8List to File
        Uint8List data = transfer.block.takeBytes();
        File file = await writeToFile(data, "file");

        // Remove from Incoming
        incoming.remove(session.peerId);

        // Call Bloc Event
        bloc.add(Received(file));
      } else {
        log.v(message.text);
      }
    }
  }
}
