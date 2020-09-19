import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

class FileManager {
  // Initialization
  Session session;
  SonarBloc bloc;
  RTCDataChannel dataChannel;

  // Maps to Track Transfer
  List<TransferFile> outgoing;
  List<TransferFile> incoming;

  // Constructor
  FileManager(this.bloc, this.session) {
    // Initialize Maps
    outgoing = List<TransferFile>();
    incoming = List<TransferFile>();

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
      incoming.add(incomingFile);
    } else {
      // Create File Object
      var outgoingFile = new TransferFile(localFile: file);

      // Set File to Outgoing Tracker
      outgoing.add(outgoingFile);
    }
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  send() async {
    // Get File thats being sent to Peer
    TransferFile transfer = outgoing.first;

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(transfer.file.openRead());

    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Update Chunk Info
      transfer.updateChunkInfo(bloc);

      // Send Binary in WebRTC Data Channel
      dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

      // End of List
      if (data.length <= 0) {
        // Send Complete Message on same DC
        dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

        // Remove from Outgoing
        outgoing.removeAt(0);

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
    var transfer = incoming.first;

    // Check if Binary
    if (message.isBinary) {
      // Add Binary to Transfer
      transfer.addChunk(message.binary, bloc);
    }
    // Check if Text
    else {
      // Check for Completion Message
      if (message.text == "SEND_COMPLETE") {
        // Write File to Disk
        File file = await transfer.writeToDisk();

        // Remove from Incoming
        incoming.removeAt(0);

        // Call Bloc Event
        bloc.add(Received(file));
      } else {
        log.v(message.text);
      }
    }
  }
}
