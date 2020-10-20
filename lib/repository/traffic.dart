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
    addProgress(file, Role.Sender);
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

  // ** Update Progress ** //
  addProgress(SonrFile file, Role role) {
    // Increase Current Chunk
    file.currentChunkNum += 1;
    var total = file.metadata.chunksTotal;

    // Find Remaining
    file.remainingChunks = total - file.currentChunkNum;

    // Calculate Progress
    file.progress = (total - file.remainingChunks) / total;

    // Logging
    log.i(enumAsString(role) +
        "Current= " +
        file.currentChunkNum.toString() +
        ". Remaining= " +
        file.remainingChunks.toString() +
        "-- " +
        (file.progress * 100).toString() +
        "%");

    // Update Cubit
    _data.progress.update(file.progress);
  }
}

// **************************** //
// ** Holds Metadata and Raw ** //
// **************************** //
class SonrFile {
  final File raw;
  final Metadata metadata;

  // Progress Variables
  int remainingChunks;
  int currentChunkNum;
  double progress;

  // ** Constructer ** //
  SonrFile(this.metadata, {this.raw}) {
    this.progress = 0.0;
    this.currentChunkNum = 0;
    this.remainingChunks = this.metadata.chunksTotal;
  }

  // ** Build from Bytes ** //
  static fromBytes(Uint8List data, String path) async {
    final buffer = data.buffer;

    File rawFile = await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    var meta = new Metadata(file: rawFile);
    return SonrFile(meta, raw: rawFile);
  }

  // ** Check if Both Fields Provided ** //
  bool isComplete() {
    return raw != null && metadata != null;
  }

  // ** Convert to Map ** //
  toMap() {
    return {
      'file': {
        'name': this.metadata.name,
        'type': enumAsString(this.metadata.type),
        'size': this.metadata.size
      }
    };
  }
}
