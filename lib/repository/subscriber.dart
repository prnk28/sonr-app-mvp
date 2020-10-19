import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// ********************************** //
// ** Socket.io Event Subscription ** //
// ********************************** //
class SocketSubscriber {
  final UserBloc _user;
  final WebBloc _web;

  SocketSubscriber(this._user, this._web) {
    // ** SocketClient Event Subscription ** //
    // -- USER CONNECTED TO SERVER --
    socket.on('connect', (_) {
      // Get/Set Socket Id
      _user.node.id = socket.id;

      // Change Status
      _web.add(Update(Status.Available));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('UPDATED', (data) {
      // Neighbor
      //log.i(data.toString());

      // Get Data
      Peer from = Peer.fromMap(data);

      // Update Graph
      _user.node.updateGraph(from);
      _web.add(Update(_user.node.status));
    });

    // -- NODE EXITED LOBBY --
    socket.on('EXITED', (data) {
      // Get Data
      Peer from = Peer.fromMap(data);

      // Check if Peer is Self
      if (from.id != _user.node.id) {
        // Neighbor
        log.i(data.toString());

        // Update Graph
        _user.node.exitGraph(from);
        _web.add(Update(_user.node.status));
      }
    });

    // -- OFFER REQUEST --
    socket.on('OFFERED', (data) {
      // Get Data
      Peer from = Peer.fromMap(data[0]);
      dynamic offer = data[1];

      // Get Metadata
      Metadata meta = new Metadata(map: offer['metadata']);

      // Log Event
      log.i("OFFERED: " + data.toString());

      // Set Status
      _user.node.status = Status.Requested;

      // Handle Offer
      _user.node.handleOffer(from, offer);
      _web.add(Update(Status.Requested, match: from, metadata: meta));
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('ANSWERED', (data) {
      // Get Data
      Peer from = Peer.fromMap(data[0]);
      dynamic answer = data[1];

      // Log Event
      log.i("ANSWERED: " + data.toString());

      // Set Status
      _user.node.status = Status.Transferring;

      // Handle Answer
      _user.node.handleAnswer(from, answer);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('DECLINED', (data) {
      // Log Event
      log.i("DECLINED: " + data.toString());
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('CANDIDATE', (data) {
      // Get Data
      Peer from = Peer.fromMap(data[0]);
      dynamic candidate = data[1];

      // Handle Candidate
      _user.node.handleCandidate(from, candidate);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETED', (data) {
      // Log Event
      log.i("COMPLETED: " + data.toString());
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      // Log Event
      log.e("ERROR: " + error.toString());
    });
  }
}
