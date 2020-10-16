import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// Connection Object
class Connection {
  // ** Reference Var ** //
  final Peer _user;

  // ** Handle Events ** //
  Connection(this._user) {
    // -- USER CONNECTED TO SOCKET SERVER --
    socket.on('CONNECTED', (data) {
      log.i("CONNECTED: " + data.toString());
      _user.eventConnected(data);
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      log.i("NODE_UPDATE: " + data.toString());
      _user.eventNodeUpdate(data);
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      log.i("NODE_EXIT: " + data.toString());
      _user.eventNodeExit(data);
    });

    // -- OFFER REQUEST --
    socket.on('PEER_OFFERED', (data) {
      log.i("PEER_OFFERED: " + data.toString());
      _user.eventPeerOffered(data);
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('PEER_ANSWERED', (data) {
      log.i("PEER_ANSWERED: " + data.toString());
      _user.eventPeerAnswered(data);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('PEER_DECLINED', (data) {
      log.i("PEER_DECLINED: " + data.toString());
      _user.eventPeerDeclined(data);
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('PEER_CANDIDATE', (data) {
      log.i("PEER_CANDIDATE: " + data.toString());
      _user.eventPeerCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETE', (data) {
      log.i("COMPLETE: " + data.toString());
      _user.eventPeerCompleted(data);
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      _user.eventError(error);
    });
  }
}
