import 'package:flutter_webrtc/webrtc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repositories/broadcast.dart';
import 'package:sonar_app/repositories/repositories.dart';

// *******************
// * Signaling Enum **
// *******************
enum RTCSignalState {
  New,
  Invite,
  Connected,
  End,
  Open,
  Closed,
  Error,
}

enum RTCEvent {
  PeersUpdate,
  Invite,
  Offer,
  Answer,
  Candidate,
  Leave,
  Close,
  Reset
}

// *********************************
// * Callbacks for Signaling API. **
// *********************************
typedef void SignalingStateFuncBack(RTCSignalState state);
typedef void StreamStateCallback(MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);

// ******************************************
// * Peer Class to Manage Individual Nodes **
// ******************************************
class Peer {
  // Properties
  String id;
  dynamic description;
  String sessionId;
  RTCPeerConnection _peerConnection;

  // Constructer
  Peer({this.id, this.description, this.sessionId, RTCPeerConnection pc}) {
    this._peerConnection = pc;
    _peerConnection.createOffer(DC_SETTINGS);
  }

  // Extend RTCPeerConnection close
  close() {
    if (_peerConnection != null) {
      _peerConnection.close();
    }
  }

  // Extend RTCPeerConnection createAnswer
  createAnswer() async {
    if (_peerConnection != null) {
      RTCSessionDescription s = await _peerConnection.createAnswer(DC_SETTINGS);
      return s;
    }
  }

  createOffer() async {
    if (_peerConnection != null) {
      RTCSessionDescription s = await _peerConnection.createOffer(DC_SETTINGS);
      return s;
    }
  }

  // Get PeerConnection from Candidate and Session
  getPeerConnection(Session session) async {
    if (_peerConnection == null) {
      _peerConnection = await session.getCandidate();
    }
  }

  // Extend RTCPeerConnection setLocalDescription
  setLocalDescription(RTCSessionDescription description) {
    if (_peerConnection != null) {
      _peerConnection.setLocalDescription(description);
    }
  }

  // Set Peer Connection from Existing One
  setPeerConnection(RTCPeerConnection pc) {
    if (_peerConnection == null) {
      _peerConnection = pc;
    }
  }

  // Extend RTCPeerConnection setLocalDescription
  setRemoteDescription(RTCSessionDescription description) {
    _peerConnection.setRemoteDescription(description);
  }
}

// *******************************************
// * Session Class to Manage P2P Connection **
// *******************************************
class Session {
  // Properties
  String id;
  String currentPeerId;

  // RTC Peer Management
  var dataChannels = new Map<String, RTCDataChannel>();
  var peerConnections = new Map<String, Peer>();
  var remoteCandidates = [];

  // Transfer Networking
  Connection _conn;
  RTCDataChannel _dataChannel;

  // Callbacks
  SignalingStateFuncBack onStateChange;
  OtherEventCallback onPeersUpdate;
  DataChannelMessageCallback onDataChannelMessage;
  DataChannelCallback onDataChannel;

  Session(Connection conn, SonarBloc bloc) {
    // Set References
    _conn = conn;

    // Set Data Channel
    this.onDataChannel = (channel) {
      _dataChannel = channel;
    };

    // Handle Data Messages
    this.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      bloc.add(Received(data));
    };
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

  getCandidate() async {
    // Create Peer Connection
    RTCPeerConnection pc =
        await createPeerConnection(ICE_CONFIG, DC_SETTINGS);

    // Initialize Ice Candidate
    pc.onIceCandidate = (candidate) {
      // Emit Socket Candidate Data
      _conn.emit(SocketEvent.CANDIDATE, data: candidate);
    };

    pc.onIceConnectionState = (state) {};

    pc.onDataChannel = (channel) {
      this.addDataChannel(id, channel);
    };

    return pc;
  }

  getPeer({id}) {
    // Check if id Provided
    if (id) {
      return peerConnections[id];
    }
    // If no Id return current match
    else {
      if (this.currentPeerId.isNotEmpty) {
        return peerConnections[this.currentPeerId];
      } else {
        throw ("Cannot Retrieve Peer");
      }
    }
  }

  send(RTCDataChannelMessage message) {
    _dataChannel.send(message);
  }

  signal(RTCEvent type, {dynamic data}) async {
    switch (type) {
      case RTCEvent.Invite:
        // Set Session Properties
        this.currentPeerId = data;
        this.id = _conn.id + '-' + data;

        if (this.onStateChange != null) {
          this.onStateChange(RTCSignalState.New);
        }

        // Get PeerConnection from Candidate
        this.getCandidate().then((pc) {
          // Create Peer
          Peer peer = new Peer(id: data);
          peer.setPeerConnection(pc);

          // Add to Map
          this.peerConnections[data] = peer;

          // Create DC
          this.createDataChannel(data, pc);
          _conn.emit(SocketEvent.OFFER);
        });

        _conn.invited = true;
        break;
      case RTCEvent.Offer:
        // Set Properties
        this.id = data['session_id'];
        this.currentPeerId = data['from'];

        // Create Peer
        Peer peer = new Peer(
            id: data['from'],
            description: data['description'],
            sessionId: data['session_id']);

        // Set State Change
        if (this.onStateChange != null) {
          this.onStateChange(RTCSignalState.New);
        }

        // Await Candidate from Peer
        await peer.getPeerConnection(this);

        // Set PeerConnection in Map
        this.peerConnections[peer.id] = peer;

        // Set Remote Description for Peer
        await peer.setRemoteDescription(new RTCSessionDescription(
            peer.description['sdp'], peer.description['type']));

        // Create Answer for PeerConnection
        RTCSessionDescription s = await peer.createAnswer();
        peer.setLocalDescription(s);

        // Send Answer to Offer
        await _conn.emit(SocketEvent.ANSWER);

        // Check Remote Candidates
        if (this.remoteCandidates.length > 0) {
          this.remoteCandidates.forEach((candidate) async {
            await peer._peerConnection.addCandidate(candidate);
          });
          this.remoteCandidates.clear();
        }
        break;
      case RTCEvent.Answer:
        var id = data['from'];
        var description = data['description'];

        var peer = this.peerConnections[id];
        if (peer != null) {
          await peer.setRemoteDescription(new RTCSessionDescription(
              description['sdp'], description['type']));
        }
        break;
      case RTCEvent.Candidate:
        var id = data['from'];
        var candidateMap = data['candidate'];
        var peer = this.peerConnections[id];
        RTCIceCandidate candidate = new RTCIceCandidate(
            candidateMap['candidate'],
            candidateMap['sdpMid'],
            candidateMap['sdpMLineIndex']);
        if (peer._peerConnection != null) {
          await peer._peerConnection.addCandidate(candidate);
        } else {
          this.remoteCandidates.add(candidate);
        }
        break;
      case RTCEvent.Close:
        var to = data['to'];
        var sessionId = data['session_id'];
        log.i('End: ' + sessionId);

        var peer = this.peerConnections[to];
        if (peer != null) {
          peer.close();
          this.peerConnections.remove(to);
        }

        var dc = this.dataChannels[to];
        if (dc != null) {
          dc.close();
          this.dataChannels.remove(to);
        }

        this.id = null;
        if (this.onStateChange != null) {
          this.onStateChange(RTCSignalState.End);
        }
        break;
      case RTCEvent.Leave:
        var id = data;
        var pc = this.peerConnections.remove(id);
        this.dataChannels.remove(id);

        if (pc != null) {
          pc.close();
        }
        this.id = null;
        if (this.onStateChange != null) {
          this.onStateChange(RTCSignalState.End);
        }
        break;
      case RTCEvent.PeersUpdate:
        List<dynamic> peers = data;
        if (this.onPeersUpdate != null) {
          Map<String, dynamic> event = new Map<String, dynamic>();
          event['self'] = this.id;
          event['peers'] = peers;
          this.onPeersUpdate(event);
        }
        break;
      case RTCEvent.Reset:
        currentPeerId = "";
        peerConnections.forEach((key, pc) {
          pc.close();
        });
        break;
      default:
        throw ("Error Handling RTC, Unknown Handle Type");
    }
  }
}
