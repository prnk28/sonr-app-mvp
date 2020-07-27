import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/repo/repo.dart';

// *******************
// * Signaling Enum **
// *******************
enum SignalingState {
  CallStateNew,
  CallStateRinging,
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
class Session {
  // WebRTC Transfer Variables
  String _sessionId;
  dynamic _peer;
  Map _peerConnections = new Map<String, RTCPeerConnection>();
  Map _dataChannels = new Map<String, RTCDataChannel>();
  var _remoteCandidates = [];

  // Callbacks
  OverrideSignalingStateCallback onStateChange;
  StreamStateCallback onLocalStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

  // References
  FileManager fileManager;
  SonarBloc bloc;

  // Constructor
  Session(this.bloc) {
    fileManager = new FileManager(bloc, this);
  }

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
    this._sessionId = sessionId;

    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
    }

    var pc = await _createPeerConnection(id);
    _peerConnections[id] = pc;
    await pc.setRemoteDescription(
        new RTCSessionDescription(description['sdp'], description['type']));
    await _createAnswer(id, pc);
    if (this._remoteCandidates.length > 0) {
      _remoteCandidates.forEach((candidate) async {
        await pc.addCandidate(candidate);
      });
      _remoteCandidates.clear();
    }
  }

  void handleAnswer(data) async {
    var id = data['from'];
    var description = data['description'];

    var pc = _peerConnections[id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }
  }

  void handleCandidate(data) async {
    var id = data['from'];
    var candidateMap = data['candidate'];
    var pc = _peerConnections[id];
    RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      _remoteCandidates.add(candidate);
    }
  }

  void handleLeave(data) {
    var id = data;
    var pc = _peerConnections.remove(id);
    _dataChannels.remove(id);

    if (pc != null) {
      pc.close();
    }
    this._sessionId = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void handleClose(data) {
    var to = data['to'];
    var sessionId = data['session_id'];
    print('bye: ' + sessionId);

    var pc = _peerConnections[to];
    if (pc != null) {
      pc.close();
      _peerConnections.remove(to);
    }

    var dc = _dataChannels[to];
    if (dc != null) {
      dc.close();
      _dataChannels.remove(to);
    }

    this._sessionId = null;
    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateBye);
    }
  }

  void close() {
    _peerConnections.forEach((key, pc) {
      pc.close();
    });
  }

// *****************************
// ** WebRTC Message Sending ***
// *****************************
  // Invite Peer
  void invite(dynamic fileInfo) {
    this._sessionId = socket.id + '-' + this.peerId();

    if (this.onStateChange != null) {
      this.onStateChange(SignalingState.CallStateNew);
    }

    _createPeerConnection(this.peerId()).then((pc) {
      _peerConnections[this.peerId()] = pc;
      _createDataChannel(this.peerId(), pc);
      _createOffer(this.peerId(), fileInfo, pc);
    });
  }

  // Leave Connection
  void leave() {
    // Tell Peers youre leaving
    socket.emit('LEAVE', {
      'session_id': this._sessionId,
      'from': socket.id,
    });

    // Reset Current Peer
    _peer = null;
  }

// ****************************
// ** WebRTC Helper Methods ***
// ****************************
  _createPeerConnection(id) async {
    RTCPeerConnection pc = await createPeerConnection(ICE_CONFIG, DC_SETTINGS);
    pc.onIceCandidate = (candidate) {
      socket.emit('CANDIDATE', {
        'to': id,
        'from': socket.id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': this._sessionId,
      });
    };

    pc.onIceConnectionState = (state) {};

    pc.onDataChannel = (channel) {
      _addDataChannel(id, channel);
    };

    return pc;
  }

  _addDataChannel(id, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {};
    channel.onMessage = (RTCDataChannelMessage data) {
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage(channel, data);
    };
    _dataChannels[id] = channel;

    if (this.onDataChannel != null) this.onDataChannel(channel);
  }

  _createDataChannel(id, RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    _addDataChannel(id, channel);
  }

  _createOffer(String id, dynamic fileInfo, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createOffer(DC_SETTINGS);
      pc.setLocalDescription(s);

      // Send on Socket.io
      socket.emit('OFFER', [
        {
          'to': id,
          'from': socket.id,
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': this._sessionId,
        },
        fileInfo
      ]);
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer(String id, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer(DC_SETTINGS);
      pc.setLocalDescription(s);

      socket.emit('ANSWER', {
        'to': id,
        'from': socket.id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': this._sessionId,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // **************************
  // ** Peer Helper Methods ***
  // **************************
  peerId() {
    if (_peer != null) {
      return this._peer["id"];
    }
    log.e("Peer Not Set");
  }

  peerProfile() {
    if (_peer != null) {
      return this._peer;
    }
    log.e("Peer Not Set");
  }

  setPeer(dynamic peer) {
    if (_peer != null) {
      log.e("Peer Already Set");
    }
    this._peer = peer;
  }
}
