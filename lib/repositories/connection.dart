import '../core/core.dart';

class Connection {
  // Session Properties
  String id;
  SonarBloc _bloc;

  // Transfer Variables
  bool initialized = false;
  bool invited = false;
  bool offered = false;

  // Manages Socket.io Events
  Connection(SonarBloc bloc) {
    // Initialize
    _bloc = bloc;

    // ** SOCKET::Connected **
    socket.on('connect', (_) async {
      log.v("Connected to Socket");
      id = socket.id;
    });

    // ** SOCKET::INFO **
    socket.on('INFO', (data) {
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
      // Add to Process
      log.v("Lobby Id: " + data);
    });

    // ** SOCKET::NEW_SENDER **
    socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      socket.emit("RECEIVING", [bloc.device.lastDirection.toReceiveMap()]);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
      // Add to Process
      log.i("NEW_SENDER: " + data);
    });

    // ** SOCKET::SENDER_UPDATE **
    socket.on('SENDER_UPDATE', (data) {
      bloc.circle.update(bloc.device.lastDirection, data);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
    });

    // ** SOCKET::SENDER_EXIT **
    socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      bloc.circle.exit(id);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.w("SENDER_EXIT: " + id);
    });

    // ** SOCKET::NEW_RECEIVER **
    socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      if (bloc.device.lastDirection != null) {
        socket.emit("SENDING", [bloc.device.lastDirection.toReceiveMap()]);
      }

      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.i("NEW_RECEIVER: " + data);
    });

    // ** SOCKET::RECEIVER_UPDATE **
    socket.on('RECEIVER_UPDATE', (data) {
      bloc.circle.update(bloc.device.lastDirection, data);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));
    });

    // ** SOCKET::RECEIVER_EXIT **
    socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      bloc.circle.exit(id);
      bloc.add(Refresh(newDirection: bloc.device.lastDirection));

      // Add to Process
      log.w("RECEIVER_EXIT: " + id);
    });

    // ** SOCKET::SENDER_OFFERED **
    socket.on('SENDER_OFFERED', (data) async {
      log.i("SENDER_OFFERED: " + data.toString());

      dynamic _offer = data[0];

      // Remove Sender from Circle
      bloc.add(Offered(profileData: bloc.circle.closest(), offer: _offer));
    });

    // ** SOCKET::NEW_CANDIDATE **
    socket.on('NEW_CANDIDATE', (data) async {
      log.i("NEW_CANDIDATE: " + data.toString());

      bloc.session.handleCandidate(data);
    });

    // ** SOCKET::RECEIVER_ANSWERED **
    socket.on('RECEIVER_ANSWERED', (data) async {
      log.i("RECEIVER_ANSWERED: " + data.toString());

      dynamic _answer = data[0];

      bloc.add(Accepted(
          bloc.circle.closest(), bloc.circle.closest()["id"], _answer));
    });

    // ** SOCKET::RECEIVER_DECLINED **
    socket.on('RECEIVER_DECLINED', (data) {
      dynamic matchId = data[0];

      bloc.add(Declined(bloc.circle.closest(), matchId));
      // Add to Process
      log.w("RECEIVER_DECLINED: " + data.toString());
    });

    // ** SOCKET::NEXT_CHUNK **
    socket.on('NEXT_CHUNK', (data) {
      bloc.session.fileManager.sendBlock(data);
      // Add to Process
      log.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // ** SOCKET::RECEIVER_COMPLETED **
    socket.on('RECEIVER_COMPLETED', (data) {
      dynamic matchId = data[0];

      bloc.add(Completed(bloc.circle.closest(), matchId));
      // Add to Process
      log.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // ** SOCKET::ERROR **
    socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });
  }

  // ** Reset Connection
  reset() {
    if (this.initialized) {
      // Reset Bools
      offered = false;
      invited = false;

      // Reset circle
      socket.emit("RESET");
      _bloc.circle.status = "Default";
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
