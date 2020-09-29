import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:graph_collection/graph.dart';

part 'web_event.dart';
part 'web_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class WebBloc extends Bloc<WebEvent, WebState> {
  // Data Providers
  Circle circle;
  Graph graph;

  // Socket Communication Booleans
  bool initialized = false;
  bool invited = false;
  bool offered = false;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Device State Subscription
  StreamSubscription deviceSubscription;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Initialization
    graph = new Graph();

    // ****************************** //
    // ** Device BLoC Subscription ** //
    // ****************************** //
    deviceSubscription = device.listen((DeviceState currDeviceState) {
      // Device can Record Data/ Portrait
      if (currDeviceState is Ready) {
        log.i("DeviceBloc State: Ready <- from WebBloc");
      }
      // Device is Tilted or Landscape
      else if (currDeviceState is Sending || currDeviceState is Receiving) {
        add(RequestSearch(userNode: currDeviceState.user));
      }
      // Interacting with another Peer
      else if (currDeviceState is Busy) {
        log.i("DeviceBloc State: Busy <- from WebBloc");
      }
      // Refreshing Sensors
      else if (currDeviceState is Refreshing) {
        log.i("DeviceBloc State: Refreshing <- from WebBloc");
      }
      // Inactive
      else {
        log.i("DeviceBloc State: Inactive <- from WebBloc");
      }
    });

    // ***************************** //
    // ** Socket Message Listener ** //
    // ***************************** //
    // -- Connected --
    socket.on('connect', (_) async {
      log.v("Connected to Socket");
      user.node.id = socket.id;
    });

    // -- SOCKET::INFO --
    socket.on('INFO', (data) {
      //bloc.add(Reload(newDirection: bloc.device.direction));
      // Add to Process
      //log.v("Lobby Id: " + data);
    });

    // ** SOCKET::NEW_SENDER **
    socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      //socket.emit("RECEIVING", [bloc.device.direction.toReceiveMap()]);
      //bloc.add(Reload(newDirection: bloc.device.direction));
      // Add to Process
      //log.i("NEW_SENDER: " + data);
    });

    // ** SOCKET::SENDER_UPDATE **
    socket.on('SENDER_UPDATE', (data) {
      //bloc.circle.update(bloc.device.direction, data);
      //bloc.add(Reload(newDirection: bloc.device.direction));
    });

    // ** SOCKET::SENDER_EXIT **
    socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      //bloc.circle.exit(id);
      //bloc.add(Reload(newDirection: bloc.device.direction));

      // Add to Process
      //log.w("SENDER_EXIT: " + id);
    });

    // ** SOCKET::NEW_RECEIVER **
    socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      //if (bloc.device.direction != null) {
      //  socket.emit("SENDING", [bloc.device.direction.toReceiveMap()]);
      // }

      //bloc.add(Reload(newDirection: bloc.device.direction));

      // Add to Process
      //log.i("NEW_RECEIVER: " + data);
    });

    // ** SOCKET::RECEIVER_UPDATE **
    socket.on('RECEIVER_UPDATE', (data) {
      // bloc.circle.update(bloc.device.direction, data);
      //bloc.add(Reload(newDirection: bloc.device.direction));
    });

    // ** SOCKET::RECEIVER_EXIT **
    socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      //bloc.circle.exit(id);
      //bloc.add(Reload(newDirection: bloc.device.direction));

      // Add to Process
      //log.w("RECEIVER_EXIT: " + id);
    });

    // ** SOCKET::SENDER_OFFERED **
    socket.on('SENDER_OFFERED', (data) async {
      //log.i("SENDER_OFFERED: " + data.toString());

      // Call offered event
      //bloc.add(HandleOffer(offer: data[0], profile: data[1]));
    });

    // ** SOCKET::NEW_CANDIDATE **
    socket.on('NEW_CANDIDATE', (data) async {
      //log.i("NEW_CANDIDATE: " + data.toString());

      rtcSession.handleCandidate(data);
    });

    // ** SOCKET::RECEIVER_ANSWERED **
    socket.on('RECEIVER_ANSWERED', (data) async {
      //log.i("RECEIVER_ANSWERED: " + data.toString());

      dynamic _answer = data[0];

      //bloc.add(HandleAnswer(bloc.circle.closestProfile(),
      //bloc.circle.closestProfile()["id"], _answer));
    });

    // ** SOCKET::RECEIVER_DECLINED **
    socket.on('RECEIVER_DECLINED', (data) {
      dynamic matchId = data[0];

      //bloc.add(HandleDecline(bloc.circle.closestProfile(), matchId));
      // Add to Process
      //log.w("RECEIVER_DECLINED: " + data.toString());
    });

    // ** SOCKET::NEXT_CHUNK **
    socket.on('NEXT_CHUNK', (data) {
      //bloc.session.fileManager.sendBlock(data);
      // Add to Process
      //log.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // ** SOCKET::RECEIVER_COMPLETED **
    socket.on('RECEIVER_COMPLETED', (data) {
      dynamic matchId = data[0];

      //bloc.add(HandleComplete(bloc.circle.closestProfile(), matchId));
      // Add to Process
      //log.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // ** SOCKET::ERROR **
    socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });

    circle = new Circle(this);
  }

  // Initial State
  WebState get initialState => Disconnected();

  // On Bloc Close
  void dispose() {
    deviceSubscription.cancel();
  }

// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<WebState> mapEventToState(
    WebEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Connect) {
      yield* _mapConnectToState(event);
    } else if (event is RequestSearch) {
      yield* _mapSendPeerToState(event);
    } else if (event is SendOffer) {
      yield* _mapInviteToState(event);
    } else if (event is HandleOffer) {
      yield* _mapOfferedToState(event);
    } else if (event is SendAuthorization) {
      yield* _mapAuthorizeToState(event);
    } else if (event is HandleAnswer) {
      yield* _mapAcceptedToState(event);
    } else if (event is HandleDecline) {
      yield* _mapDeclinedToState(event);
    } else if (event is BeginTransfer) {
      yield* _mapTransferToState(event);
    } else if (event is HandleReceived) {
      yield* _mapReceivedToState(event);
    } else if (event is HandleComplete) {
      yield* _mapCompletedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
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

// ********************
// ** Connect Event ***
// ********************
  Stream<WebState> _mapConnectToState(Connect event) async* {
    // Check Status
    if (needSetup()) {
      // Emit to Socket.io from User Peer Node
      socket.emit("CONNECT", [user.node.locationToMap(), user.profile.toMap()]);
      initialized = true;

      // Fake Select File in Queue
      File transferToSend =
          await getAssetFileByPath("assets/images/fat_test.jpg");
      data.add(QueueFile(receiving: false, file: transferToSend));

      // Device Pending State
      yield Connected();
    }
  }

// **************************
// ** RequestSearch Event ***
// **************************
  Stream<WebState> _mapSendPeerToState(RequestSearch event) async* {
    // Check Init Status
    if (ready()) {
      // Get Peer Map
      Map peerMap = event.userNode.toMap();

      // Set Delay
      await new Future.delayed(Duration(milliseconds: 500));

      // Send to Server
      socket.emit("REQUEST_SEARCH", peerMap);
    }

    // Set Suspend state with lastState
    yield Searching();
  }

// ***********************
// ** SendInvite Event ***
// ***********************
  Stream<WebState> _mapInviteToState(SendOffer event) async* {
    // Check Status
    if (ready()) {
      // Set Invited
      invited = true;

      // Set Peer
      rtcSession.peerId = circle.closestId();

      // Create Offer and Emit
      rtcSession.invite(
          this.circle.closestId(), data.outgoing.first.toString());

      // Device Pending State
      yield Pending(match: circle.closestProfile());
    }
  }

// ********************
// ** Offered Event ***
// ********************
  Stream<WebState> _mapOfferedToState(HandleOffer event) async* {
    // Check Status
    if (ready()) {
      // Set Offered and Peer
      offered = true;
      rtcSession.peerId = event.profile["id"];

      // Add Incoming File Info
      data.add(QueueFile(
        receiving: true,
      ));

      // Device Pending State
      yield Pending(match: circle.closestProfile(), offer: event.offer);
    }
  }

// ******************************
// ** SendAuthorization Event ***
// ******************************
  Stream<WebState> _mapAuthorizeToState(SendAuthorization event) async* {
    // Check Status
    if (initialized) {
      // Yield Receiver Decision
      if (event.decision) {
        // Create Answer
        rtcSession.handleOffer(event.offer);
        yield Transferring();
      }
      // Receiver Declined
      else {
        // Reset Peer
        rtcSession.resetPeer();

        // Send Decision
        socket.emit("DECLINE", event.matchId);
        add(Reset());
      }
    }
  }

// *************************
// ** HandleAnswer Event ***
// *************************
  Stream<WebState> _mapAcceptedToState(HandleAnswer event) async* {
    // Check Status
    if (initialized) {
      // Handle Answer
      rtcSession.handleAnswer(event.answer);

      // Begin Transfer

      yield Transferring();
    }
  }

// **************************
// ** HandleDecline Event ***
// **************************
  Stream<WebState> _mapDeclinedToState(HandleDecline event) async* {
    // Check Status
    if (initialized) {
      // Reset Peer
      rtcSession.resetPeer();

      // Emit Decision to Server
      yield Failed(profile: event.profile, matchId: event.matchId);
    }
  }

// *********************
// ** Transfer Event ***
// *********************
  Stream<WebState> _mapTransferToState(BeginTransfer event) async* {
    // Check Status
    if (initialized) {
      // Begin Transfer
      data.add(SendChunks());

      // Emit Decision to Server
      yield Transferring();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<WebState> _mapReceivedToState(HandleReceived event) async* {
    // Check Status
    if (initialized) {
      // Emit Decision to Server
      yield Complete("RECEIVER", file: event.data);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<WebState> _mapCompletedToState(HandleComplete event) async* {
    // Check Status
    if (initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<WebState> _mapResetToState(Reset event) async* {
    // Check Status
    if (initialized) {
      // Reset Connection
      socket.emit("RESET");

      // Reset RTC
      rtcSession.close();
      rtcSession.resetPeer();

      // Reset Circle
      circle.reset();

      // Set Delay
      await new Future.delayed(Duration(seconds: 1));

      // Yield Ready
      yield Connected();
    } else {
      add(Connect());
    }
  }
}
