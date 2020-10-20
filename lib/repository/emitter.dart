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
  offer(Peer to, Metadata meta) async {
    session.id = this.id + '-' + to.id;

    // Change Session State
    session.updateState(SignalingState.CallStateNew);

    // Add Peer Connection
    RTCPeerConnection pc = await this.newPeerConnection(to.id);

    // Initialize RTC Sender Connection
    session.initializePeer(this.role, pc, to);

    try {
      // Create Offer Description
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("OFFER", Offer.create(this, to, meta, s));
      log.i("OFFER: " + Offer.create(this, to, meta, s));
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
      socket.emit("ANSWER", Answer.create(this, match, s));
    } catch (e) {
      print(e.toString());
    }
  }

  complete(Peer match) {
    // Emit to Socket.io
    socket.emit("COMPLETE", [this.toMap(), match.id]);
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
      socket.emit("CANDIDATE", Candidate.create(this, id, candidate));
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
