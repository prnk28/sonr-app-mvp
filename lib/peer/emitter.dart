part of 'peer.dart';

enum OutgoingMessage {
  Connect,
  Update,
  Offer,
  Answer,
  Decline,
  Candidate,
  Complete,
  Failed,
  Exit,
}

extension SocketEmitter on Peer {
  // ** Emit Event/Data Message via Sockets ** //
  void emit(OutgoingMessage msg, {dynamic data}) {
    // Check if Null
    if (data == null) data = {};

    // Initialize Parameters
    String event = enumAsString(msg).toUpperCase();
    data['from'] = this.toMap();

    // Emit Message
    _connection.emit(event, data);
  }
}

extension RTCEmitter on Peer {
  // ** Invite Peer to Transfer ** //
  void invite(Peer match, Metadata meta) async {
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
      this.emit(OutgoingMessage.Offer, data: {
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

      this.emit(OutgoingMessage.Answer, data: {
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
      this.emit(OutgoingMessage.Candidate, data: {
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
}
