import 'package:sonar_app/repositories/broadcast.dart';

import '../core/core.dart';

class Connection {
  // Networking
  Session session;
  Broadcast broadcast;

  // Session Properties
  String id;

  // Transfer Variables
  bool initialized = false;
  bool invited = false;
  bool offered = false;

  // ** Constructer with SonarBloc
  Connection(SonarBloc bloc) {
    session = new Session(this, bloc);
    broadcast = new Broadcast(this, bloc);
  }

  // ** Broadcast -- Event Extension
  emit(event, {dynamic data}) {
    if (event is SocketEvent) {
      broadcast.event(event, data: data);
    } else {
      throw ("Not Valid Event to Emit Add to SocketEvent");
    }
  }

  // ** WebRTC -- Handle Extension
  handle(RTCEvent type, {data}) async {
    session.signal(type, data: data);
  }

  // ** Reset Connection
  reset() {
    if (this.initialized) {
      // Reset Bools
      offered = false;
      invited = false;

      // Reset Socket and Session
      session.signal(RTCEvent.Reset);
      broadcast.event(SocketEvent.RESET);
    }
  }

  // ** BOOL: Check to see if waiting to Initialize
  bool needSetup() {
    if (!this.initialized) {
      return true;
    }
    log.e("Already Initialized");
    return false;
  }

  // ** BOOL: Check to see if ready to Invite/Offer/Send/Receive
  bool ready() {
    if (initialized && !invited) {
      return true;
    } else if (initialized && !offered) {
      return true;
    } else {
      log.e("Not Ready to Send/Receive/Invite/Offer");
      return false;
    }
  }

  // ** BOOL: Check to see if nobody invited/offered
  bool noContact() {
    if (!offered && !invited) {
      return true;
    }
    return false;
  }
}
