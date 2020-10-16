import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

enum OutgoingMessage {
  Connect,
  Update,
  Offer,
  Answer,
  Decline,
  Candidate,
  Complete,
  Failed,
  Exit,
}

// Connection Object
class Connection {
  // ** Reference Var ** //
  final Peer _user;
  Socket _socket;

  // ** Handle Events ** //
  Connection(this._user) {
    // Initialize Objects
    _socket = io('http://match.sonr.io', <String, dynamic>{
      'transports': ['websocket'],
    });

    // -- USER CONNECTED TO SOCKET SERVER --
    _socket.on('CONNECTED', (data) {
      _user.eventConnected(data);
    });

    // -- UPDATE TO A NODE IN LOBBY --
    _socket.on('NODE_UPDATE', (data) {
      _user.eventNodeUpdate(data);
    });

    // -- NODE EXITED LOBBY --
    _socket.on('NODE_EXIT', (data) {
      _user.eventNodeExit(data);
    });

    // -- OFFER REQUEST --
    _socket.on('PEER_OFFERED', (data) {
      _user.eventPeerOffered(data);
    });

    // -- MATCH ACCEPTED REQUEST --
    _socket.on('PEER_ANSWERED', (data) {
      _user.eventPeerAnswered(data);
    });

    // -- MATCH DECLINED REQUEST --
    _socket.on('PEER_DECLINED', (data) {
      _user.eventPeerDeclined(data);
    });

    // -- MATCH ICE CANDIDATES --
    _socket.on('PEER_CANDIDATE', (data) {
      _user.eventPeerCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    _socket.on('COMPLETE', (data) {
      _user.eventPeerCompleted(data);
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    _socket.on('ERROR', (error) {
      _user.eventError(error);
    });
  }

  // ** Send Events ** //
  emit(String event, dynamic data) {
    _socket.emit(event, data);
  }
}
