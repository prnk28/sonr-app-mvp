part of 'peer.dart';

enum OutgoingEvent {
  CONNECT,
  UPDATE,
  OFFER,
  ANSWER,
  DECLINE,
  CANDIDATE,
  COMPLETE,
  FAILED,
  EXIT,
}

// ******************************** //
// ** SocketClient Event Sending ** //
// ******************************** //
extension SocketEmitter on Peer {
  // ** Emit Event/Data Message via Sockets ** //
  void send(OutgoingEvent type, {dynamic data}) {
    // Check if Null
    if (data == null) data = {};

    // Initialize Parameters
    data['from'] = this.toMap();

    // Emit Message
    socket.emit(enumAsString(type), data);
  }
}

// ************************** //
// ** WebRTC Event Sending ** //
// ************************** //
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
      this.send(OutgoingEvent.OFFER, data: {
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

      this.send(OutgoingEvent.ANSWER, data: {
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
      this.send(OutgoingEvent.CANDIDATE, data: {
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
