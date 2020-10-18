part of 'peer.dart';

// *************************** //
// ** WebRTC Event Handling ** //
// *************************** //
extension RTCHandler on Peer {
  // ** Handle Peer Authorization ** //
  handleAnswer(dynamic data) async {
    // Get Match Node
    Peer match = new Peer(map: data["from"]);
    var description = data['description'];

    // Add Peer Connection
    var pc = _session.peerConnections[match.id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }
  }

  // ** Peer Requested User ** //
  handleOffer(dynamic data) async {
    // Get Peer
    Peer match = new Peer(map: data["from"]);

    // Update Signalling State
    _session.updateState(SignalingState.CallStateNew,
        newId: data['session_id']);

    // Create Peer Connection
    var pc = await this.newPeerConnection(match.id);

    // Initialize RTC Receiver Connection
    _session.initializePeer(true, pc, match, description: data['description']);

    // Set Candidates
    await _session.setRemoteCandidates(pc);
  }

  // ** Handle ICE Candidate Received ** //
  handleCandidate(data) async {
    // Get Match Node
    Peer match = new Peer(map: data["from"]);
    var candidateMap = data['candidate'];
    var pc = _session.peerConnections[match.id];

    // Setup Candidate
    RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      _session.remoteCandidates.add(candidate);
    }
  }

  // ** Handle Peer Change ** //
  handlePeerUpdate(data) {
    List<dynamic> peers = data;
    if (_session.onPeersUpdate != null) {
      Map<String, dynamic> event = new Map<String, dynamic>();
      event['self'] = this.id;
      event['peers'] = peers;
      _session.onPeersUpdate(event);
    }
  }

  // ** Handle Peer Exit from RTC Session ** //
  handleCancel(data) {
    // Retrieve Data
    Peer match = new Peer(map: data["from"]);

    // Remove RTC Connection
    var pc = _session.peerConnections[match.id];
    if (pc != null) {
      pc.close();
      _session.peerConnections.remove(match.id);
    }

    // Remove DataChannels
    var dc = _session.dataChannels[match.id];
    if (dc != null) {
      dc.close();
      _session.dataChannels.remove(match.id);
    }

    // Reset Status
    _session.updateState(SignalingState.CallStateBye);
  }
}

// ************************** //
// ** Peer Status Handling ** //
// ************************** //
extension StatusHandler on Peer {
  // ** Get Private Status **
  Status get status {
    return _status;
  }

  // ** Set Status/ Change LastUpdated **
  set status(Status status) {
    // Update to Given Status
    _status = status;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

  // ** Set OLC from Current Location **
  setLocation() async {
    // Get Location
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    log.i("Current Position: " + position.toString());

    // Encode OLC
    this.olc = OLC.encode(position.latitude, position.longitude);
  }
}
