import 'repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

// *******************
// * Signaling Enum **
// *******************
enum SignalingState {
  CallStateNew,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

// *********************************
// * Callbacks for Signaling API. **
// *********************************
typedef void OverrideSignalingStateCallback(SignalingState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);

// *******************
// * Initialization **
// *******************
class RTCSession {
  // Session Id
  String id;

  // WebRTC
  Map peerConnections = new Map<String, RTCPeerConnection>();
  Map _dataChannels = new Map<String, RTCDataChannel>();
  var remoteCandidates = [];

  // Callbacks
  OverrideSignalingStateCallback onStateChange;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

// *************************
// ** Socket.io Handlers ***
// *************************
  void handleCandidate(data) async {
    // Get Match Node
    Peer match = Peer.fromMap(data["from"]);
    var candidateMap = data['candidate'];
    var pc = peerConnections[match.id];

    // Setup Candidate
    RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      remoteCandidates.add(candidate);
    }
  }

  void handleLeave(data) {
    var id = data;
    var pc = peerConnections.remove(id);
    _dataChannels.remove(id);

    if (pc != null) {
      pc.close();
    }
    this.id = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void handleExit(data) {
    var to = data['to'];
    var sessionId = data['session_id'];
    print('bye: ' + sessionId);

    var pc = this.peerConnections[to];
    if (pc != null) {
      pc.close();
      this.peerConnections.remove(to);
    }

    var dc = _dataChannels[to];
    if (dc != null) {
      dc.close();
      _dataChannels.remove(to);
    }

    this.id = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void exit() {
    peerConnections.forEach((key, pc) {
      pc.close();
    });
  }

// ****************************
// ** WebRTC Helper Methods ***
// ****************************
  addDataChannel(id, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };
    _dataChannels[id] = channel;

    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  createDataChannel(id, RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    addDataChannel(id, channel);
  }

  initializePeer(bool isReceiver, RTCPeerConnection pc, Peer match,
      {dynamic description}) async {
    // Listen to ICE Connection
    pc.onIceConnectionState = (state) {};

    // Add Data Channel
    pc.onDataChannel = (channel) {
      this.addDataChannel(id, channel);
    };

    // Set Values
    this.peerConnections[match.id] = pc;

    // Check if Receiving
    if (isReceiver) {
      // Validate Description Data
      if (description != null) {
        // Set Remote Description
        await pc.setRemoteDescription(
            new RTCSessionDescription(description['sdp'], description['type']));
      } else {
        log.e("Description Data not Provided for Receiver");
      }
    }
    // Peer is Sending
    else {
      // Create New DataChannel
      this.createDataChannel(match.id, pc);
    }
  }

  setRemoteCandidates(RTCPeerConnection pc) async {
    if (this.remoteCandidates.length > 0) {
      this.remoteCandidates.forEach((candidate) async {
        await pc.addCandidate(candidate);
      });
      this.remoteCandidates.clear();
    }
  }

  updateState(SignalingState state, {String newId}) {
    // Validate Existence
    if (this.onStateChange != null) {
      // Check if New Call
      if (state == SignalingState.CallStateNew) {
        // Set Session Id
        this.id = newId;
      }

      // Set New State
      this.onStateChange(state);
    }
  }
}
