import 'package:sonar_app/repository/repository.dart';

// **************************** //
// ** Socket Messaging Enums ** //
// **************************** //
enum Incoming {
  Connected,
  Disconnected,
  Updated,
  Exited,
  Offered,
  Answered,
  Declined,
  Candidate,
  Error
}

enum Outgoing {
  Status,
  Offer,
  Answer,
  Decline,
  Candidate,
  Exited,
}

// ********************************** //
// ** Socket.io Event Subscription ** //
// ********************************** //
class SocketSubscriber {
  final void Function(Incoming, dynamic) onSocketMessage;

  SocketSubscriber(this.onSocketMessage) {
    // ** SocketClient Event Subscription ** //
    // -- USER CONNECTED TO SERVER --
    socket.on('connect', (_) {
      // Send Callback
      onSocketMessage(Incoming.Connected, socket.id);
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('UPDATED', (data) {
      // Send Callback
      onSocketMessage(Incoming.Updated, data);
    });

    // -- NODE EXITED LOBBY --
    socket.on('EXITED', (data) {
      // Send Callback
      onSocketMessage(Incoming.Exited, data);
    });

    // -- OFFER REQUEST --
    socket.on('OFFERED', (data) {
      // Send Callback
      onSocketMessage(Incoming.Offered, data);
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('ANSWERED', (data) {
      // Send Callback
      onSocketMessage(Incoming.Answered, data);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('DECLINED', (data) {
      // Send Callback
      onSocketMessage(Incoming.Declined, data);
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('CANDIDATE', (data) {
      // Send Callback
      onSocketMessage(Incoming.Candidate, data);
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (data) {
      // Send Callback
      onSocketMessage(Incoming.Error, data);
    });
  }
}
