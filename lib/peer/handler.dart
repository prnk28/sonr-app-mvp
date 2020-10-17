part of 'peer.dart';

enum IncomingEvent {
  CONNECTED,
  NODE_UPDATE,
  NODE_EXIT,
  PEER_OFFERED,
  PEER_ANSWERED,
  PEER_DECLINED,
  PEER_CANDIDATE,
  COMPLETED,
  ERROR
}

// ********************************* //
// ** SocketClient Event Handling ** //
// ********************************* //
extension SocketHandler on Peer {
  // ** Initialize SocketClient Connection ** //
  handleEvent(IncomingEvent event, dynamic data) {
    switch (event) {
      case IncomingEvent.CONNECTED:
        // Set LobbyId
        this.lobbyId = data["lobbyId"];
        break;
      case IncomingEvent.NODE_UPDATE:
        // Get Peer
        Peer peer = Peer.fromMap(data["from"]);

        // Update Graph
        this.updateGraph(peer);
        break;
      case IncomingEvent.NODE_EXIT:
        // Get Peer
        Peer peer = Peer.fromMap(data["from"]);

        // Update Graph
        this.exitGraph(peer);
        break;
      case IncomingEvent.PEER_OFFERED:
        // Set Status
        this.status = Status.Requested;

        // Handle Offer
        this.handleOffer(data);
        break;
      case IncomingEvent.PEER_ANSWERED:
        // Set Status
        this.status = Status.Transferring;

        // Handle Answer
        this.handleAnswer(data);
        break;
      case IncomingEvent.PEER_DECLINED:
        // TODO: Handle this case.
        break;
      case IncomingEvent.PEER_CANDIDATE:
        // Handle Candidate
        this.handleCandidate(data);
        break;
      case IncomingEvent.COMPLETED:
        // TODO: Handle this case.
        break;
      case IncomingEvent.ERROR:
        log.e("ERROR: " + data.toString());
        break;
    }
  }
}

// *************************** //
// ** WebRTC Event Handling ** //
// *************************** //
extension RTCHandler on Peer {
  // ** Handle Peer Authorization ** //
  handleAnswer(dynamic msg) async {
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
  handleOffer(dynamic data) async {
    // Get Peer
    Peer match = Peer.fromMap(data["from"]);

    // Update Signalling State
    _session.updateState(SignalingState.CallStateNew,
        newId: data['session_id']);

    // Create Peer Connection
    var pc = await this.newPeerConnection(match.id);

    // Initialize RTC Receiver Connection
    _session.initializePeer(true, pc, match, description: data['description']);

    // TODO: Send Answer on Auth
    // await this.createAnswer(match.id, pc);

    // Set Candidates
    await _session.setRemoteCandidates(pc);
  }

  // ** Handle ICE Candidate Received ** //
  void handleCandidate(data) async {
    // Get Match Node
    Peer match = Peer.fromMap(data["from"]);
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
  handleExit(data) {
    // Retrieve Data
    Peer match = Peer.fromMap(data["from"]);
    var sessionId = data['session_id'];

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
