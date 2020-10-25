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
  Map dataChannels = new Map<String, RTCDataChannel>();
  var remoteCandidates = [];

  // Callbacks
  OverrideSignalingStateCallback onStateChange;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

// ****************************
// ** WebRTC Object Methods ***
// ****************************
  addDataChannel(id, RTCDataChannel channel) {
    // Send Callback to DataBloc
    channel.onDataChannelState = (e) {};

    // Add Message as Callback
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };

    // Add Channel to List
    dataChannels[id] = channel;

    // Subscribe to Callback
    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  createDataChannel(id, RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    addDataChannel(id, channel);
  }

  cancel(Node match) {
    // Remove RTC Connection
    var pc = this.peerConnections[match.id];
    if (pc != null) {
      pc.close();
      this.peerConnections.remove(match.id);
    }

    // Remove DataChannel
    var dc = this.dataChannels[match.id];
    if (dc != null) {
      dc.close();
      this.dataChannels.remove(match.id);
    }

    // Change Status
    this.updateState(SignalingState.CallStateBye);
  }

  handleCandidate(Node match, dynamic data) async {
    // Get Match Node
    var candidateMap = data['candidate'];
    var pc = this.peerConnections[match.id];

    // Setup Candidate
    RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      this.remoteCandidates.add(candidate);
    }
  }

  initializePeer(Role role, RTCPeerConnection pc, Node match,
      {dynamic description}) async {
    // Listen to ICE Connection
    pc.onIceConnectionState = (state) {};

    // Add Data Channel
    pc.onDataChannel = (channel) {
      this.addDataChannel(match.id, channel);
    };

    // Set Values
    this.peerConnections[match.id] = pc;

    // Check if Receiving
    if (role == Role.Receiver) {
      // Validate Description Data
      if (description != null) {
        // Set Remote Description
        await pc.setRemoteDescription(
            new RTCSessionDescription(description['sdp'], description['type']));
      }
      // Log Error
      else {
        log.e("Description Data not Provided for Receiver");
      }
    }
    // Peer is Sending
    else {
      // Create New DataChannel
      this.createDataChannel(match.id, pc);
    }
  }

  newPeerConnection(id, Node user) async {
    // Create New RTC Peer Connection
    RTCPeerConnection pc =
        await createPeerConnection(RTC_CONFIG, RTC_CONSTRAINTS);

    // Send ICE Message
    pc.onIceCandidate = (candidate) {
      socket.emit("CANDIDATE", [
        user.toMap(),
        id,
        {
          'candidate': {
            'sdpMLineIndex': candidate.sdpMlineIndex,
            'sdpMid': candidate.sdpMid,
            'candidate': candidate.candidate,
          },
          'session_id': this.id,
        }
      ]);
    };
    return pc;
  }

  peersUpdated(data) {
    List<dynamic> peers = data;
    if (this.onPeersUpdate != null) {
      Map<String, dynamic> event = new Map<String, dynamic>();
      event['self'] = this.id;
      event['peers'] = peers;
      this.onPeersUpdate(event);
    }
  }

  reset({Node match}) {
    // Check if Match Provided
    if (match != null) {
      // Close Connection and DataChannel
      this.peerConnections[match.id].close();
      this.dataChannels[match.id].close();

      // Remove from Connection and DataChannel
      this.peerConnections.remove(match.id);
      this.dataChannels.remove(match.id);

      // Clear Session ID
      this.id = null;
    }
    
    // Change State
    updateState(null);
  }

  setRemoteCandidates(RTCPeerConnection pc) async {
    if (this.remoteCandidates.length > 0) {
      this.remoteCandidates.forEach((candidate) async {
        await pc.addCandidate(candidate);
      });
      this.remoteCandidates.clear();
    }
  }

  updateState(SignalingState state) {
    // Validate Existence
    if (this.onStateChange != null) {
      // Check if New Call
      if (state == SignalingState.CallStateNew) {
      }
      // Check if End Call
      else if (state == SignalingState.CallStateBye) {
        this.id = null;
      }

      // Set New State
      this.onStateChange(state);
    }
  }
}
