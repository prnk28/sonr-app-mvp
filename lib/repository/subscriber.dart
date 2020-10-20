import 'package:sonar_app/bloc/bloc.dart';
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
      _web.add(Load(event: General(data, 'UPDATED')));
    });

    // -- NODE EXITED LOBBY --
    socket.on('EXITED', (data) {
      _web.add(Load(event: General(data, 'EXITED')));
    });

    // -- OFFER REQUEST --
    socket.on('OFFERED', (data) {
      // Inform WebBloc
      _web.add(Update(Status.Offered, offer: Offer(data)));
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('ANSWERED', (data) {
      // Inform WebBloc
      _web.add(Update(Status.Answered, answer: Answer(data)));
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('DECLINED', (data) {
      _web.add(Load(event: General(data, 'DECLINED')));
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('CANDIDATE', (data) {
      // Handle Candidate
      _user.node.handleCandidate(Peer.fromMap(data[0]), data[1]);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETED', (data) {
      _web.add(Load(event: General(data, 'COMPLETED')));
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      _web.add(Load(event: General(error, 'ERROR')));
    });
  }
}
