import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// ** Message Socket **
class Emitter {
  // References
  final Node user;
  final Node match;
  final RTCSession session;

  // Upon RTC Connection
  RTCDataChannel dataChannel;

  // ** Constructer **
  Emitter(this.user, this.match, this.session, {var offer}) {
    // Set Session id
    if (offer == null) {
      session.id = user.id + '-' + match.id;
    }
    // Get Session Id
    else {
      session.id = offer['session_id'];
    }

    // Update Session State
    session.updateState(SignalingState.CallStateNew);
  }

  // Signal Accepted to Peer
  answer(Node match, String sessionId, RTCPeerConnection pc) async {
    try {
      // Create Answer Description
      RTCSessionDescription s = await pc.createAnswer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("ANSWER", [
        user.toMap(),
        match.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': sessionId,
        }
      ]);
    } catch (e) {
      print(e.toString());
    }
  }

  // Signal Invite to Peer
  invite(
      Node match, String sessionId, RTCPeerConnection pc, Metadata meta) async {
    try {
      // Set Match
      match = match;

      // Create Offer Description
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("OFFER", [
        user.toMap(),
        match.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': sessionId,
          'metadata': meta.toMap()
        }
      ]);
    } catch (e) {
      print(e.toString());
    }
  }
}
