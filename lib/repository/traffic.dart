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
  final DataBloc _data;
  final RTCSession _session;

  // Traffic Maps - MatchId/File
  List<SonrFile> _incoming;
  List<SonrFile> _outgoing;
  SonrFile current;

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
  addFile(TrafficDirection direction, {File file, Metadata meta}) {
    // Check Incoming/Outgoing
    switch (direction) {
      case TrafficDirection.Incoming:
        // Create and Add to Incoming map
        _incoming.add(new SonrFile(Role.Receiver, metadata: meta));

        // Set as current
        current = _incoming.first;
        break;
      case TrafficDirection.Outgoing:
        // Create and Add to Outgoing File Map
        _outgoing.add(new SonrFile(Role.Sender, file: file));

        // Set as current
        current = _outgoing.first;
        break;
    }
  }

  // ** Return Current File Metadata as Map ** //
  toInfoMap() {
    if (this.current != null) {
      return this.current.metadata.toMap();
    }
  }

  // ** Send Chunk on Channel ** //
  transmit(Uint8List chunk) {
    // Send on Channel
    _dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

    // Update Progress
    _data.progress.update(current.metadata.addProgress(Role.Sender));
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
        current = null;
        break;
      case TrafficDirection.Outgoing:
        // Clear All
        if (matchId == null) {
          _outgoing.clear();
        }

        // Clear One
        _outgoing.remove(matchId);
        current = null;
        break;
    }
  }
}

// **************************** //
// ** Holds Metadata and Raw ** //
// **************************** //
class SonrFile {
  final Role role;
  final File file;
  Metadata metadata;

  // ** Constructer ** //
  SonrFile(this.role, {this.file, this.metadata}) {
    // Check what kind of data provided
    if (this.file != null) {
      this.metadata = new Metadata(file: this.file);
    }
  }

  // ** Build from Bytes ** //
  static fromBytes(Uint8List data, String path) async {
    final buffer = data.buffer;

    File rawFile = await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    return SonrFile(Role.Viewer, file: rawFile);
  }

  // ** Progress Forward Metadata ** //
  addProgress() {
    return this.metadata.addProgress(role);
  }

  // ** Convert to Map ** //
  toMap() {
    return {
      'role': enumAsString(this.role),
      'file': {
        'name': this.metadata.name,
        'type': enumAsString(this.metadata.type),
        'size': this.metadata.size
      }
    };
  }
}
