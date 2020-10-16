part of 'peer.dart';

// ********************************* //
// ** SocketClient Event Handling ** //
// ********************************* //
extension SocketHandler on Peer {
  // ** Initialize SocketClient Connection ** //
  // -- USER CONNECTED TO SOCKET SERVER --
  eventConnected(dynamic data) {
    // Update Beacon Settings
    this.lobbyId = data["lobbyId"];
  }

  // -- UPDATE TO A NODE IN LOBBY --
  eventNodeUpdate(dynamic data) {
    // Get Peer
    Peer peer = Peer.fromMap(data["from"]);

    // Update Graph
    this.updateGraph(peer);
  }

  // -- NODE EXITED LOBBY --
  eventNodeExit(dynamic data) {
    // Get Peer
    Peer peer = Peer.fromMap(data["from"]);

    // Update Graph
    this.exitGraph(peer);
  }

  // -- OFFER REQUEST --
  eventPeerOffered(dynamic data) {
    // Set Status
    this.status = PeerStatus.Requested;

    // Handle Offer
    this.handleOffer(data);
  }

  // -- MATCH ACCEPTED REQUEST --
  eventPeerAnswered(dynamic data) {
    // Set Status
    this.status = PeerStatus.Transferring;

    this.handleAnswer(data);
  }

  // -- MATCH DECLINED REQUEST --
  eventPeerDeclined(dynamic data) {}

  // -- MATCH ICE CANDIDATES --
  eventPeerCandidate(dynamic data) {
    _session.handleCandidate(data);
  }

  // -- MATCH RECEIVED FILE --
  eventPeerCompleted(dynamic data) {}

  // -- ERROR OCCURRED (Cancelled, Internal) --
  eventError(dynamic error) {
    log.e("ERROR: " + error);
  }
}

// *************************** //
// ** WebRTC Event Handling ** //
// *************************** //
extension RTCHandler on Peer {
  // ** Handle Peer Authorization ** //
  void handleAnswer(dynamic msg) async {
    // Get Match Node
    Peer match = Peer.fromMap(msg["from"]);
    var description = msg['description'];

    // Add Peer Connection
    var pc = _session.peerConnections[match.id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }
  }

  // ** Peer Requested User ** //
  void handleOffer(dynamic data) async {
    // Get Peer
    Peer match = Peer.fromMap(data["from"]);

    // Update Signalling State
    _session.updateState(SignalingState.CallStateNew,
        newId: data['session_id']);

    // Create Peer Connection
    var pc = await this.newPeerConnection(match.id);

    // Initialize RTC Receiver Connection
    _session.initializePeer(true, pc, match, description: data['description']);

    // Create Answer
    await this.createAnswer(match.id, pc);

    // Set Candidates
    await _session.setRemoteCandidates(pc);
  }

  // ** Handle Peer Change ** //
  void handlePeerUpdate(data) {
    List<dynamic> peers = data;
    if (_session.onPeersUpdate != null) {
      Map<String, dynamic> event = new Map<String, dynamic>();
      event['self'] = this.id;
      event['peers'] = peers;
      _session.onPeersUpdate(event);
    }
  }
}
