import 'package:sonar_app/core/core.dart';

// Event Types
enum SocketEvent {
  INITIALIZE,
  SENDING,
  RECEIVING,
  OFFER,
  ANSWER,
  CANDIDATE,
  DECLINE,
  PROGRESS,
  NEXT_BLOCK,
  COMPLETE,
  CANCEL,
  LEAVE,
  RESET,
}

// Broadcast Class to Manage Socket.io
class Broadcast {
  // ** Properties
  Connection _conn;
  Session _session;
  Socket _socket = io('http://match.sonr.io', <String, dynamic>{
    'transports': ['websocket'],
  });

  // ** Constructor
  Broadcast(Connection conn, SonarBloc bloc) {
    // Set Properties
    _conn = conn;
    _session = _conn.session;

    // SOCKET::Connected
    _socket.on('connect', (_) async {
      log.v("Connected to Socket");
      _conn.id = _socket.id;
    });

    // SOCKET::INFO
    _socket.on('INFO', (data) {
      _conn.initialized = true;
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
      // Add to Process
      log.v("Lobby Id: " + data);
    });

    // SOCKET::NEW_SENDER
    _socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      _socket.emit("RECEIVING", [bloc.device.lastDirection.toReceiveMap()]);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
      // Add to Process
      log.i("NEW_SENDER: " + data);
    });

    // SOCKET::SENDER_UPDATE
    _socket.on('SENDER_UPDATE', (data) {
      bloc.circle.update(bloc.device.lastDirection, data);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
    });

    // SOCKET::SENDER_EXIT
    _socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      bloc.circle.exit(id);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.w("SENDER_EXIT: " + id);
    });

    // SOCKET::NEW_RECEIVER
    _socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      if (bloc.device.lastDirection != null) {
        _socket.emit("SENDING", [bloc.device.lastDirection.toReceiveMap()]);
      }

      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.i("NEW_RECEIVER: " + data);
    });

    // SOCKET::RECEIVER_UPDATE
    _socket.on('RECEIVER_UPDATE', (data) {
      bloc.circle.update(bloc.device.lastDirection, data);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
    });

    // SOCKET::RECEIVER_EXIT
    _socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      bloc.circle.exit(id);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.w("RECEIVER_EXIT: " + id);
    });

    //SOCKET::SENDER_OFFERED
    _socket.on('SENDER_OFFERED', (data) async {
      log.i("SENDER_OFFERED: " + data.toString());

      dynamic _offer = data[0];

      // Remove Sender from Circle
      bloc.add(Offered(profileData: bloc.circle.closest(), offer: _offer));
    });

    // SOCKET::NEW_CANDIDATE
    _socket.on('NEW_CANDIDATE', (data) async {
      log.i("NEW_CANDIDATE: " + data.toString());

      _conn.session.signal(RTCEvent.Candidate, data: data);
    });

    // SOCKET::RECEIVER_ANSWERED
    _socket.on('RECEIVER_ANSWERED', (data) async {
      log.i("RECEIVER_ANSWERED: " + data.toString());

      dynamic _answer = data[0];

      bloc.add(Accepted(
          bloc.circle.closest(), bloc.circle.closest()["id"], _answer));
    });

    // SOCKET::RECEIVER_DECLINED
    _socket.on('RECEIVER_DECLINED', (data) {
      dynamic matchId = data[0];

      bloc.add(Declined(bloc.circle.closest(), matchId));
      // Add to Process
      log.w("RECEIVER_DECLINED: " + data.toString());
    });

    // SOCKET::RECEIVER_COMPLETED
    _socket.on('RECEIVER_COMPLETED', (data) {
      dynamic matchId = data[0];

      bloc.add(Completed(bloc.circle.closest(), matchId));
      // Add to Process
      log.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // SOCKET::ERROR
    _socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });
  }

  // ** Handle Event
  event(SocketEvent type, {dynamic data}) async {
    switch (type) {
      case SocketEvent.INITIALIZE:
        // Emit Socket
        _socket.emit('INITIALIZE', data);
        break;
      case SocketEvent.SENDING:
        _socket.emit('SENDING', data);
        break;
      case SocketEvent.RECEIVING:
        _socket.emit('RECEIVING', data);
        break;
      case SocketEvent.OFFER:
        try {
          // Get Peer from Data
          Peer currentPeer = _session.getPeer();
          RTCSessionDescription s = await currentPeer.createOffer();
          currentPeer.setLocalDescription(s);

          _conn.offered = true;

          _socket.emit("OFFER", {
            'to': data,
            'from': _conn.id,
            'description': {'sdp': s.sdp, 'type': s.type},
            'session_id': _session.id,
          });
        } catch (e) {
          print(e.toString());
        }
        break;
      case SocketEvent.ANSWER:
        try {
          // Get Peer from Data
          Peer currentPeer = _session.getPeer();

          // Create Session Description
          RTCSessionDescription sd = await currentPeer.createAnswer();

          // Set Local Description
          currentPeer.setLocalDescription(sd);

          // Emit Socket
          _socket.emit('ANSWER', {
            'to': currentPeer.id,
            'from': _conn.id,
            'description': {'sdp': sd.sdp, 'type': sd.type},
            'session_id': _session.id
          });
        } catch (e) {
          print(e.toString());
        }
        break;
      case SocketEvent.CANDIDATE:
        RTCIceCandidate candidate = data as RTCIceCandidate;
        // Send ICECandidate to Peer
        _socket.emit('CANDIDATE', {
          'to': _session.currentPeerId,
          'from': _conn.id,
          'candidate': {
            'sdpMLineIndex': candidate.sdpMlineIndex,
            'sdpMid': candidate.sdpMid,
            'candidate': candidate.candidate,
          },
          'session_id': _session.id
        });
        break;
      case SocketEvent.DECLINE:
        _socket.emit("DECLINE", _session.currentPeerId);
        break;
      case SocketEvent.PROGRESS:
        // TODO: Handle this case.
        break;
      case SocketEvent.NEXT_BLOCK:
        // TODO: Handle this case.
        break;
      case SocketEvent.COMPLETE:
        _socket.emit("COMPLETE", data);
        break;
      case SocketEvent.CANCEL:
        // TODO: Handle this case.
        break;
      case SocketEvent.LEAVE:
        _socket.emit('LEAVE', {
          'session_id': _conn.session.id,
          'from': _conn.id,
        });
        break;
      case SocketEvent.RESET:
        _socket.emit("RESET");
        break;
    }
  }
}
