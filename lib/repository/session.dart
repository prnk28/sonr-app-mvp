import 'package:sonar_app/repository/repository.dart';

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
  // Management
  String sessionId;
  String matchId;

  // WebRTC
  Map peerConnections = new Map<String, RTCPeerConnection>();
  Map dataChannels = new Map<String, RTCDataChannel>();
  var remoteCandidates = [];

  // Callbacks
  OverrideSignalingStateCallback onStateChange;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

// *************************
// ** Socket.io Handlers ***
// *************************
  void handlePeerUpdate(data) {
    List<dynamic> peers = data;
    if (this.onPeersUpdate != null) {
      Map<String, dynamic> event = new Map<String, dynamic>();
      event['self'] = socket.id;
      event['peers'] = peers;
      this.onPeersUpdate(event);
    }
  }

  void handleOffer(data) async {
    var id = data['from'];
    var description = data['description'];
    var sessionId = data['session_id'];
    this.sessionId = sessionId;

    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
    }

    var pc = await initPeerConnection(id);
    peerConnections[id] = pc;
    await pc.setRemoteDescription(
        new RTCSessionDescription(description['sdp'], description['type']));
    await createAnswer(id, pc);
    if (this.remoteCandidates.length > 0) {
      remoteCandidates.forEach((candidate) async {
        await pc.addCandidate(candidate);
      });
      remoteCandidates.clear();
    }
  }

  void handleAnswer(data) async {
    var id = data['from'];
    var description = data['description'];

    var pc = peerConnections[id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }
  }

  void handleCandidate(data) async {
    var id = data['from'];
    var candidateMap = data['candidate'];
    var pc = peerConnections[id];
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
    dataChannels.remove(id);

    if (pc != null) {
      pc.close();
    }
    this.sessionId = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void handleClose(data) {
    var to = data['to'];

    var pc = peerConnections[to];
    if (pc != null) {
      pc.close();
      peerConnections.remove(to);
    }

    var dc = dataChannels[to];
    if (dc != null) {
      dc.close();
      dataChannels.remove(to);
    }

    this.sessionId = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void close() {
    peerConnections.forEach((key, pc) {
      pc.close();
    });
    matchId = null;
  }

// *********************
// ** WebRTC Methods ***
// *********************
  void invite(String peer, String fileInfo) {
    matchId = peer;
    this.sessionId = socket.id + '-' + matchId;

    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
    }

    initPeerConnection(matchId).then((pc) {
      peerConnections[matchId] = pc;
      createDataChannel(matchId, pc);
      createOffer(matchId, fileInfo, pc);
    });
  }

  void leave() {
    // Tell Peers youre leaving
    socket.emit('LEAVE', {
      'session_id': this.sessionId,
      'from': socket.id,
    });

    // Reset Current Peer
    matchId = null;
  }

// ****************************
// ** WebRTC Helper Methods ***
// ****************************
  initPeerConnection(id) async {
    RTCPeerConnection pc =
        await createPeerConnection(RTC_CONFIG, RTC_CONSTRAINTS);
    pc.onIceCandidate = (candidate) {
      socket.emit('CANDIDATE', {
        'to': id,
        'from': socket.id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': this.sessionId,
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onDataChannel = (channel) {
      addDataChannel(id, channel);
    };

    return pc;
  }

  addDataChannel(id, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };
    dataChannels[id] = channel;

    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  createDataChannel(id, RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    addDataChannel(id, channel);
  }

  createOffer(String id, String fileInfo, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      socket.emit('OFFER', {
        'to': id,
        'from': socket.id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': this.sessionId,
        'file_info': fileInfo
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createAnswer(String id, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      socket.emit('ANSWER', {
        'to': id,
        'from': socket.id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': this.sessionId,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
