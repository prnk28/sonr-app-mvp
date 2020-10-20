part of 'peer.dart';

// ******************************* //
// ** Socket.io Event Messaging ** //
// ******************************* //
extension SocketEmitter on Peer {
  // ** Node Attempting to Connect ** //
  bool connect() {
    // Check if Peer Located
    if (this.status == Status.Standby) {
      // Get Headers
      var headers = {
        'deviceId': this.id,
        'lobby': this.olc, // RoomId from Location
      };

      // Set on Socket
      socket.io.options['extraHeaders'] = headers;

      // Connect to Socket
      socket.connect();
      return true;
    }
    // Incorrect status
    else {
      log.e("User node not located");
      return false;
    }
  }

  // ** Node has Updated ** //
  update(Status newStatus) {
    // Update Status
    this.status = newStatus;

    // Emit to Server
    socket.emit("UPDATE", this.toMap());
  }
}

// **************************** //
// ** WebRTC Event Messaging ** //
// **************************** //
extension RTCEmitter on Peer {
  // ** Invite Peer to Transfer ** //
  offer(Peer match, dynamic fileInfo) async {
    // Change Session State
    session.id = this.id + '-' + match.id;
    session.updateState(SignalingState.CallStateNew);

    // Add Peer Connection
    RTCPeerConnection pc = await this.newPeerConnection(match.id);

    // Initialize RTC Sender Connection
    session.initializePeer(Role.Sender, pc, match);

    try {
      // Create Offer Description
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("OFFER", [
        this.toMap(),
        match.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.id,
          'metadata': fileInfo
        }
      ]);
    } catch (e) {
      print(e.toString());
    }
  }

  // ** Create WebRTC Answer (Post Authentication) ** //
  answer(Peer match, RTCPeerConnection pc) async {
    try {
      // Create Answer Description
      RTCSessionDescription s = await pc.createAnswer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("ANSWER", [
        this.toMap(),
        match.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.id,
        }
      ]);
    } catch (e) {
      print(e.toString());
    }
  }

  decline(Peer match) {
    // Emit to Socket.io
    socket.emit("DECLINE", [this.toMap(), match.id]);
  }

  // ** Create new RTCPeerConnection ** //
  newPeerConnection(id) async {
    // Create New RTC Peer Connection
    RTCPeerConnection pc =
        await createPeerConnection(RTC_CONFIG, RTC_CONSTRAINTS);

    // Send ICE Message
    pc.onIceCandidate = (candidate) {
      socket.emit("CANDIDATE", [
        this.toMap(),
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

  // ** Exit the RTCSession ** //
  exit() {
    session.peerConnections.forEach((key, pc) {
      pc.close();
    });
  }
}
