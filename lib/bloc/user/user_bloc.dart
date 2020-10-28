import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // References
  SignalBloc signal;
  DataBloc data;

  // Data Providers
  Circle circle;
  Emitter emitter;
  Node node;
  RTCSession session;
  ActivePeersCubit activePeers;

  UserBloc() : super(null) {
    circle = new Circle();
    session = new RTCSession();
    activePeers = new ActivePeersCubit();
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // Profile
    if (event is UserStarted) {
      yield* _mapUserStartedState(event);
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedState(event);

      // Graphing
    } else if (event is GraphUpdated) {
      yield* _mapGraphUpdatedState(event);
    } else if (event is GraphExited) {
      yield* _mapGraphExitedState(event);

      // Node Emitter - Status
    } else if (event is NodeSearch) {
      yield* _mapNodeSearchState(event);
    } else if (event is NodeAvailable) {
      yield* _mapNodeAvailableState(event);
    } else if (event is NodeBusy) {
      yield* _mapNodeBusyState(event);
    } else if (event is NodeReset) {
      yield* _mapNodeResetState(event);
    } else if (event is NodeCancel) {
      yield* _mapNodeCancelState(event);

      // Node - Sender
    } else if (event is NodeOffered) {
      yield* _mapNodeOfferedState(event);
    } else if (event is PeerAuthorized) {
      yield* _mapNodeAuthorizedState(event);
    } else if (event is PeerRejected) {
      yield* _mapNodeRejectedState(event);
    } else if (event is NodeTransmitted) {
      yield* _mapNodeTransmittedState(event);

      // Node - Receiver
    } else if (event is PeerRequested) {
      yield* _mapNodeRequestedState(event);
    } else if (event is NodeAccepted) {
      yield* _mapNodeAcceptedState(event);
    } else if (event is NodeDeclined) {
      yield* _mapNodeDeclinedState(event);
    } else if (event is NodeReceived) {
      yield* _mapNodeReceivedState(event);
    } else if (event is NodeCompleted) {
      yield* _mapNodeCompletedState(event);
    }
  }

  void dispose() {
    data.close();
    signal.close();
  }

// ************************
// ** Profile Management **
// ************************
// Get User Ready on Device
  Stream<UserState> _mapUserStartedState(UserStarted event) async* {
    // Set References
    data = event.data;
    signal = event.signal;

    // Retrieve Profile
    var profile = await Profile.retrieve();

    // No Profile
    if (profile == null) {
      // Change State
      yield ProfileLoadFailure();
    }
    // Profile Found
    else {
      // Initialize User Node
      node = new Node(profile);

      // Set Node Location
      await node.setLocation();
      node.status = Status.Offline;

      // Profile Ready
      yield ProfileLoadSuccess(node);
    }
  }

// Update Profile/Contact Info
  Stream<UserState> _mapProfileUpdatedState(ProfileUpdated event) async* {
    // Save to Box
    await Profile.update(event.newProfile);

    // Reinitialize User Node
    node = new Node(event.newProfile);

    // Set Node Location
    await node.setLocation();
    node.status = Status.Offline;

    // Profile Ready
    yield ProfileLoadSuccess(node);
  }

// **********************
// ** Graph Management **
// **********************
// [Peer] has updated Information
  Stream<UserState> _mapGraphUpdatedState(GraphUpdated event) async* {
    // Check User Status
    if (node.status == Status.Searching) {
      // Update Circle
      circle.updateGraph(node, event.from);

      // Update Active Peers
      var peers = circle.getZonedPeers(node);
      activePeers.update(peers);
    }
    // If User is just active
    else if (node.status == Status.Available) {
      yield NodeAvailableInProgress(node);
    }
  }

  // [Peer] exited Pool of Neighbors
  Stream<UserState> _mapGraphExitedState(GraphExited event) async* {
    // Check User Status
    if (node.status != Status.Searching) {
      // Update Circle
      circle.exitGraph(event.from);

      // Update Active Peers
      var peers = circle.getZonedPeers(node);
      activePeers.update(peers);
    }
    // If User is just active
    else if (node.status == Status.Available) {
      yield NodeAvailableInProgress(node);
    }
  }

// ***************************
// ** Node Emitter - Status **
// ***************************
// [User] is Searching
  Stream<UserState> _mapNodeSearchState(NodeSearch event) async* {
    // Update Status
    if (node != null) {
      // Update Status
      node.status = Status.Searching;

      // Emit to Server
      socket.emit("UPDATE", node.toMap());

      // Change LastUpdated
      node.lastUpdated = DateTime.now();
    } else {
      log.e("Node not active");
    }

    // Update Peers
    var peers = circle.getZonedPeers(node);
    activePeers.update(peers);
    yield NodeSearchInProgress(node);
  }

  // [User] is Available
  Stream<UserState> _mapNodeAvailableState(NodeAvailable event) async* {
    // Update Status
    if (node != null) {
      // Update Status
      node.status = Status.Available;

      // Emit to Server
      socket.emit("UPDATE", node.toMap());

      // Change LastUpdated
      node.lastUpdated = DateTime.now();
    } else {
      log.e("Node not active");
    }

    // Update Peers
    yield NodeAvailableInProgress(node);
  }

  // [User] is Busy
  Stream<UserState> _mapNodeBusyState(NodeBusy event) async* {
    // Update Status
    if (node != null) {
      // Update Status
      node.status = Status.Busy;

      // Emit to Server
      socket.emit("UPDATE", node.toMap());

      // Change LastUpdated
      node.lastUpdated = DateTime.now();
    } else {
      log.e("Node not active");
    }
  }

  // [User] is Reset
  Stream<UserState> _mapNodeResetState(NodeReset event) async* {
    // Reset Session
    session.reset(match: event.match);
  }

  // [Peer] has Cancelled
  Stream<UserState> _mapNodeCancelState(NodeCancel event) async* {
    // Cancel Transfer
    session.cancel(event.match);

    // Change State
    yield NodeTransferFailure(event.match);
  }

// ***************************
// ** Node Emitter - Sender **
// ***************************
// [User] Send Offer to another peer
  Stream<UserState> _mapNodeOfferedState(NodeOffered event) async* {
    // Start Session by Creating Emitter
    emitter = new Emitter(node, event.to, session);

    // Add Peer Connection
    RTCPeerConnection pc = await session.newPeerConnection(event.to.id, node);

    // Initialize RTC Sender Connection
    session.initializePeer(Role.Sender, pc, event.to);

    // Invite Peer
    await emitter.invite(event.to, session.id, pc, event.metadata);

    // Change Status
    add(NodeBusy());
    yield NodeRequestInProgress(event.to);
  }

  // [Peer] Authorized Offer
  Stream<UserState> _mapNodeAuthorizedState(PeerAuthorized event) async* {
    // Get Match Node
    var description = event.answer['description'];

    // Add Peer Connection
    var pc = session.peerConnections[event.match.id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }

    // DataBloc is Waiting for this State
    yield NodeTransferInitial(event.match);
  }

  // [User] is Sending Chunks
  Stream<UserState> _mapNodeTransmittedState(NodeTransmitted event) async* {
    // Change State
    yield NodeTransferInProgress(event.match);
  }

  // [Peer] Rejected Offer
  Stream<UserState> _mapNodeRejectedState(PeerRejected event) async* {
    yield NodeRequestFailure(event.from);
  }

// *****************************
// ** Node Emitter - Receiver **
// *****************************
  // [Peer] Has Sent Request
  Stream<UserState> _mapNodeRequestedState(PeerRequested event) async* {
    // Change State
    yield NodeRequestInitial(event.from, event.offer, event.metadata);
  }

  // [User] Authorized Offer
  Stream<UserState> _mapNodeAcceptedState(NodeAccepted event) async* {
    // Get Data
    var offer = event.offer;
    var match = event.match;
    var metadata = event.metadata;

    // Start Session by Creating Emitter
    emitter = new Emitter(node, match, session, offer: offer);

    // Create Peer Connection
    var pc = await session.newPeerConnection(match.id, node);

    // Initialize RTC Receiver Connection
    session.initializePeer(Role.Receiver, pc, match,
        description: offer['description']);

    // Set Candidates
    await session.setRemoteCandidates(pc);

    // Send Answer
    await emitter.answer(match, session.id, pc);

    // Change Status
    add(NodeBusy());
    yield NodeReceiveInitial(metadata, match);
  }

  // [User] Has ReceivedChunk
  Stream<UserState> _mapNodeReceivedState(NodeReceived event) async* {
    // Change State
    yield NodeReceiveInProgress(event.metadata);
  }

// [User] Rejected Offer
  Stream<UserState> _mapNodeDeclinedState(NodeDeclined event) async* {
    // Emit to Socket.io
    socket.emit("DECLINE", [node.toMap(), event.to.id]);

    // Update Status
    add(NodeAvailable());
  }

  // User/[Peer] have completed transfer
  Stream<UserState> _mapNodeCompletedState(NodeCompleted event) async* {
    // Set to Search if Applicable
    if (event.file == null) {
      // Change State
      yield NodeTransferSuccess(event.receiver);
    } else {
      // Change State
      yield NodeReceiveSuccess(event.file, event.metadata);
    }
  }
}
