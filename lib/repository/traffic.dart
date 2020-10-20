import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

// ** Enum for Traffic Management ** //
enum TrafficDirection { Incoming, Outgoing }

// *********************************** //
// ** Data Transfer Traffic Manager ** //
// *********************************** //
class Traffic {
  // Dependencies
  final DataBloc _data;
  final RTCSession _session;

  // Traffic Maps - MatchId/File
  List<SonrFile> _incoming;
  List<SonrFile> _outgoing;

  // DataChannel
  bool isChannelActive;
  RTCDataChannel _dataChannel;

  // ** Constructer ** //
  Traffic(this._data, this._session) {
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
        // Add Binary to Transfer
        _data.add(AddChunk(message.binary));
      }
    };
  }

  // ** Add File to Incoming/Outgoing ** //
  addFile(TrafficDirection direction, SonrFile file) {
    // Check Incoming/Outgoing
    switch (direction) {
      case TrafficDirection.Incoming:
        _incoming.add(file);
        break;
      case TrafficDirection.Outgoing:
        // Add to Outgoing File Map
        _outgoing.add(file);
        break;
    }
  }

  // ** Send Chunk on Channel ** //
  transmit(SonrFile file, Uint8List chunk) {
    // Send on Channel
    _dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

    // Update Progress
    file.addProgress(_data, Role.Sender);
  }

  // ** Clear a Map ** //
  clear(TrafficDirection direction, {String matchId}) {
    switch (direction) {
      case TrafficDirection.Incoming:
        // Clear All
        if (matchId == null) {
          _incoming.clear();
        }

        // Clear One
        _incoming.remove(matchId);
        break;
      case TrafficDirection.Outgoing:
        // Clear All
        if (matchId == null) {
          _outgoing.clear();
        }

        // Clear One
        _outgoing.remove(matchId);
        break;
    }
  }
}