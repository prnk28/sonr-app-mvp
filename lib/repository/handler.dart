part of 'peer.dart';

// *************************** //
// ** WebRTC Event Handling ** //
// *************************** //
extension RTCHandler on Peer {
  // ** Handle Peer Authorization ** //
  handleAnswer(Peer match, dynamic answer) async {
    // Get Match Node
    var description = answer['description'];

    // Add Peer Connection
    var pc = session.peerConnections[match.id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }
  }

  // ** Peer Requested User ** //
  handleOffer(Peer match, dynamic offer) async {
    // Update Signalling State
    session.updateState(SignalingState.CallStateNew,
        newId: offer['session_id']);

    // Create Peer Connection
    var pc = await this.newPeerConnection(match.id);

    // Initialize RTC Receiver Connection
    session.initializePeer(true, pc, match, description: offer['description']);

    // Set Candidates
    await session.setRemoteCandidates(pc);
  }

  // ** Handle ICE Candidate Received ** //
  handleCandidate(Peer match, dynamic data) async {
    // Get Match Node
    var candidateMap = data['candidate'];
    var pc = session.peerConnections[match.id];

    // Setup Candidate
    RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      session.remoteCandidates.add(candidate);
    }
  }

  // ** Handle Peer Change ** //
  handlePeerUpdate(data) {
    List<dynamic> peers = data;
    if (session.onPeersUpdate != null) {
      Map<String, dynamic> event = new Map<String, dynamic>();
      event['self'] = this.id;
      event['peers'] = peers;
      session.onPeersUpdate(event);
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
