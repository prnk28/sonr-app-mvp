part of 'peer.dart';

extension SocketManager on Peer {}

extension RTCManager on Peer {
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
