part of 'peer.dart';

// *************************** //
// ** WebRTC Event Handling ** //
// *************************** //
extension RTCHandler on Peer {
  // ** Handle Peer Authorization ** //
  handleAnswer(Answer answer) async {
    // Add Peer Connection
    var pc = session.peerConnections[answer.from.id];
    if (pc != null) {
      await pc.setRemoteDescription(answer.description);
    }
  }

  // ** Peer Requested User ** //
  handleOffer(Offer offer) async {
    // Create Peer Connection
    var pc = await this.newPeerConnection(offer.from.id);

    // Initialize RTC Receiver Connection
    session.initializePeer(this.role, pc, offer.from,
        description: offer.description);

    // Set Candidates
    await session.setRemoteCandidates(pc);

    // Send Answer After
    await answer(offer.from, pc);
  }

  // ** Handle ICE Candidate Received ** //
  handleCandidate(Candidate candidate) async {
    // Get Match Node
    var pc = session.peerConnections[candidate.from.id];

    // Setup Candidate
    if (pc != null) {
      await pc.addCandidate(candidate.candidate);
    } else {
      session.remoteCandidates.add(candidate);
    }
  }

  // ** Handle Peer Exit from RTC Session ** //
  handleCancel(data) {
    // Retrieve Data
    Peer match = Peer.fromMap(data["from"]);

    // Remove RTC Connection
    var pc = session.peerConnections[match.id];
    if (pc != null) {
      pc.close();
      session.peerConnections.remove(match.id);
    }

    // Remove DataChannels
    var dc = session.dataChannels[match.id];
    if (dc != null) {
      dc.close();
      session.dataChannels.remove(match.id);
    }

    // Reset Status
    session.updateState(SignalingState.CallStateBye);
  }
}

// ************************** //
// ** Peer Status Handling ** //
// ************************** //
extension StatusHandler on Peer {
  // ** Set OLC from Current Location **
  setLocation() async {
    // Get Location
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Encode OLC
    this.olc = OLC.encode(position.latitude, position.longitude, codeLength: 8);
  }
}
