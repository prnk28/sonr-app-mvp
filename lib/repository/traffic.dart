import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// ** Enum for Traffic Management ** //
enum TrafficDirection { Incoming, Outgoing }

// *********************************** //
// ** Data Transfer Traffic Manager ** //
// *********************************** //
class Traffic {
  // Dependencies
  final RTCSession _session;

  // Traffic Maps - MatchId/File
  List<SonrFile> _incoming;
  List<SonrFile> _outgoing;

  // DataChannel
  bool isChannelActive;
  RTCDataChannel _dataChannel;

  // Callbacks
  void Function(SonrFile) onAddFile;
  void Function(Uint8List) onBinaryChunk;
  void Function() onTransferComplete;

  // ** Constructer ** //
  Traffic(this._session) {
    // Initialize Maps
    _incoming = new List<SonrFile>();
    _outgoing = new List<SonrFile>();

    // Listen to DataChannel Status
    _session.onDataChannel = (channel) {
      // Check Channel Status
      _dataChannel = channel;
    };

    // Handle DataChannel Message
    _session.onDataChannelMessage = (dc, RTCDataChannelMessage message) async {
      // Check if Binary
      if (message.isBinary) {
        // Send CallBack
        if (onBinaryChunk != null) onBinaryChunk(message.binary);
      }
      // Check if Text
      else {
        // Check for Completion Message
        if (message.text == "SEND_COMPLETE") {
          // Send CallBack
          if (onTransferComplete != null) onTransferComplete();
        } else {
          log.v(message.text);
        }
      }
    };
  }

  // ** Add File to Incoming ** //
  addIncoming( Metadata meta) {
    // Create SonrFile
    SonrFile file = new SonrFile(metadata: meta);

    // Add To Incoming
    _incoming.add(file);

    // Send CallBack
    if (onAddFile != null) onAddFile(file);
  }

  // ** Add File to Outgoing ** //
  addOutgoing({File rawFile}) async {
    // Get Dummy RawFile
    File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

    // Create SonrFile
    SonrFile file = new SonrFile(file: dummyFile);

    // Add to Outgoing
    _outgoing.add(file);

    // Send CallBack
    if (onAddFile != null) onAddFile(file);
  }

  // ** Sender Completed Sending ** //
  complete(SonrFile file) {
    // Send Complete Message on same DC
    _dataChannel.send(RTCDataChannelMessage("SEND_COMPLETE"));

    // Clear outgoing traffic
    this.clear(TrafficDirection.Outgoing);
  }

  // ** Send Chunk on Channel ** //
  transmit(SonrFile file, Uint8List chunk) {
    // Check Progress
    if (file.progress.round() != 100) {
      // Send on Channel
      _dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));
    }
  }

  // ** Clear a Map ** //
  clear(TrafficDirection direction, {String matchId}) {
    switch (direction) {
      case TrafficDirection.Incoming:
        // Clear All
        if (matchId == null) {
          _incoming.clear();

          // Clear Current File
          onAddFile(null);
        }

        // Clear One
        _incoming.remove(matchId);
        break;
      case TrafficDirection.Outgoing:
        // Clear All
        if (matchId == null) {
          _outgoing.clear();

          // Clear Current File
          onAddFile(null);
        }

        // Clear One
        _outgoing.remove(matchId);
        break;
    }
  }
}
