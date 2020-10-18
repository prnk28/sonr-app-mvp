part of 'peer.dart';

// ******************************* //
// ** Socket.io Event Messaging ** //
// ******************************* //
extension SocketEmitter on Peer {
  connect() {
    // Get Headers
    var headers = {
      'id': this.id, // Update Socket ID
      'lobby': this.location.olc, // RoomId from Location
      'node': this.toMap() // Node Info
    };

    // Set on Socket
    socket.io.options['extraHeaders'] = headers;

    // Connect to Socket
    socket.connect();
  }
}

// **************************** //
// ** WebRTC Event Messaging ** //
// **************************** //
extension RTCEmitter on Peer {
  // ** Invite Peer to Transfer ** //
  invite(Peer match, Metadata meta) async {
    // Change Session State
    _session.updateState(SignalingState.CallStateNew,
        newId: this.id + '-' + match.id);

    // Add Peer Connection
    RTCPeerConnection pc = await this.newPeerConnection(match.id);

    // Initialize RTC Sender Connection
    _session.initializePeer(false, pc, match);

    // Send Offer
    this.createOffer(match.id, meta.toMap(), pc);
  }

  // ** Create WebRTC Offer ** //
  createOffer(String id, dynamic fileInfo, RTCPeerConnection pc) async {
    try {
      // Create Session Description
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("OFFER", {
        'to': id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': _session.id,
        'file_info': fileInfo
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // ** Create WebRTC Answer (Post Authentication) ** //
  createAnswer(String id, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      socket.emit("ANSWER", {
        'to': id,
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': _session.id,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // ** Create new RTCPeerConnection ** //
  newPeerConnection(id) async {
    // Create New RTC Peer Connection
    RTCPeerConnection pc =
        await createPeerConnection(RTC_CONFIG, RTC_CONSTRAINTS);

    // Send ICE Message
    pc.onIceCandidate = (candidate) {
      socket.emit("CANDIDATE", {
        'to': id,
        'candidate': {
          'sdpMLineIndex': candidate.sdpMlineIndex,
          'sdpMid': candidate.sdpMid,
          'candidate': candidate.candidate,
        },
        'session_id': this.id,
      });
    };
    return pc;
  }

  // ** Exit the RTCSession ** //
  sendExit() {
    _session.peerConnections.forEach((key, pc) {
      pc.close();
    });
  }
}
