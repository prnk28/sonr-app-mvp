import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

// ********************************** //
// ** Socket.io Event Subscription ** //
// ********************************** //
class SocketSubscriber {
  final Peer _node;
  final WebBloc _web;

  SocketSubscriber(this._node, this._web) {
    // ** SocketClient Event Subscription ** //
    // -- USER CONNECTED TO SERVER --
    socket.on('READY', (data) {
      // Log Event
      log.i("READY");

      // Change Status
      _web.add(Update(Status.Available));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('UPDATED', (data) {
      log.i(data.toString());
      // Check if Peer is Self
      if (data['id'] != _node.id) {
        // Get Peer
        Peer neighbor = Peer.fromMap(data);

        // Update Graph
        _node.updateGraph(neighbor);
      }
    });

    // -- NODE EXITED LOBBY --
    socket.on('EXITED', (data) {
      // Log Event
      log.i("EXITED: " + data.toString());

      // Get Peer
      Peer neighbor = Peer.fromMap(data['from']);

      // Update Graph
      _node.exitGraph(neighbor);
    });

    // -- OFFER REQUEST --
    socket.on('OFFERED', (data) {
      // Log Event
      log.i("OFFERED: " + data.toString());

      // Set Status
      _node.status = Status.Requested;

      // Handle Offer
      _node.handleOffer(data);
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('ANSWERED', (data) {
      // Log Event
      log.i("ANSWERED: " + data.toString());

      // Set Status
      _node.status = Status.Transferring;

      // Handle Answer
      _node.handleAnswer(data);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('DECLINED', (data) {
      // Log Event
      log.i("DECLINED: " + data.toString());
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('CANDIDATE', (data) {
      // Log Event
      log.i("CANDIDATE: " + data.toString());

      // Handle Candidate
      _node.handleCandidate(data);
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
