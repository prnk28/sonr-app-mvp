import 'repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

// Connection Object
class Connection extends Socket {
  Connection() : super(null, '', null) {
    // -- USER CONNECTED TO SOCKET SERVER --
    this.on('CONNECTED', (data) {
      // Update Beacon Settings
      // _web.add(Handle(IncomingMessage.Connected, data));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    this.on('NODE_UPDATE', (data) {
      //_web.add(Handle(IncomingMessage.Updated, data));
    });

    // -- NODE EXITED LOBBY --
    this.on('NODE_EXIT', (data) {
      //_web.add(Handle(IncomingMessage.Exited, data));
    });

    // -- OFFER REQUEST --
    this.on('PEER_OFFERED', (data) {
      //_web.add(Handle(IncomingMessage.Offered, data));
    });

    // -- MATCH ACCEPTED REQUEST --
    this.on('PEER_ANSWERED', (data) {
      //_web.add(Handle(IncomingMessage.Answered, data));
    });

    // -- MATCH DECLINED REQUEST --
    this.on('PEER_DECLINED', (data) {
      //_web.add(Handle(IncomingMessage.Declined, data));
    });

    // -- MATCH ICE CANDIDATES --
    this.on('PEER_CANDIDATE', (data) {
      //_user.update(Action.AddCandidate, data: data);
    });

    // -- MATCH RECEIVED FILE --
    this.on('COMPLETE', (data) {
      //_web.add(Handle(IncomingMessage.Completed, data));
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    this.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });
  }
}
