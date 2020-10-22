import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  Peer node;

  // Data Providers
  RTCSession session;
  DirectedValueGraph _graph;

  UserBloc() : super(null) {
    // Initialize Providers
    session = new RTCSession();
    _graph = new DirectedValueGraph();
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
    } else if (event is GraphZonedPeers) {
      yield* _mapGraphZonedPeersState(event);

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
    } else if (event is NodeAuthorized) {
      yield* _mapNodeAuthorizedState(event);
    } else if (event is NodeRejected) {
      yield* _mapNodeRejectedState(event);

      // Node - Receiver
    } else if (event is NodeRequested) {
      yield* _mapNodeRequestedState(event);
    } else if (event is NodeAccepted) {
      yield* _mapNodeAcceptedState(event);
    } else if (event is NodeDeclined) {
      yield* _mapNodeDeclinedState(event);
    } else if (event is NodeCandidate) {
      yield* _mapNodeCandidateState(event);
    }
  }

// ************************
// ** Profile Management **
// ************************
// Get User Ready on Device
  Stream<UserState> _mapUserStartedState(UserStarted event) async* {
    // Retrieve Profile
    var profile = await Profile.retrieve();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Change State
      yield ProfileLoadFailure();
    }
    // Profile Found
    else {
      // Initialize User Node
      node = new Peer(profile);

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
    node = new Peer(event.newProfile);

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
    // Get Data
    Peer peer = event.from;

    // Check User Status
    if (node.isNotBusy()) {
      // Find Previous Node
      Peer previousNode = _graph.singleWhere((element) => element.id == peer.id,
          orElse: () => null);

      // Remove Peer Node
      _graph.remove(previousNode);

      // Check Node Status: Senders are From
      if (node.canSendTo(event.from)) {
        // Calculate Difference and Create Edge
        _graph.setToBy<double>(
            node.id, event.from, node.getDifference(event.from));
      }

      // Update Active Peers
      add(GraphZonedPeers());
      yield NodeSearchInProgress(node);
    }
  }

  // [Peer] exited Pool of Neighbors
  Stream<UserState> _mapGraphExitedState(GraphExited event) async* {
    // Get Data
    Peer peer = event.from;

    // Check User Status
    if (node.isNotBusy()) {
      // Find Previous Node
      var previousNode = _graph.singleWhere((element) => element.id == peer.id,
          orElse: () => null);

      // Remove Peer Node
      _graph.remove(previousNode);

      // Update Active Peers
      add(GraphZonedPeers());
      yield NodeSearchInProgress(node);
    }
  }

  // Retrieve All Peers by Zone
  Stream<UserState> _mapGraphZonedPeersState(GraphZonedPeers event) async* {
    // Initialize Data Objects
    Map<Peer, double> costs = new Map<Peer, double>();
    List<Peer> activePeers = new List<Peer>();

    // Get Receivers
    var receivers = _graph.linkTos(this);

    // Check then Iterate
    if (receivers.length > 0) {
      // Get Receivers
      var receivers = _graph.linkTos(this);

      // Iterate Receivers
      for (Peer receiver in receivers) {
        // Get Cost
        var cost = _graph.getBy<double>(this, receiver);

        // Place in Map
        costs[receiver] = cost.val as double;

        // ** Assign active to list **
        // Check if off Screen
        if (cost.val > 180 && cost.val != -1) {
          // Set as off screen
          receiver.proximity = Proximity.Away;
        } else {
          // TODO: Assign by UltraSonic Proximity
          receiver.proximity = Proximity.Near;
          activePeers.add(receiver);
        }
      }
      // Yield Active Peers
      yield NodeSearchSuccess(node, activePeers);
    }
    // Yield No Peers Found
    yield NodeSearchFailure(node);
  }

// ***************************
// ** Node Emitter - Status **
// ***************************
// [User] is Searching
  Stream<UserState> _mapNodeSearchState(NodeSearch event) async* {
    // Update Status
    node.status = Status.Searching;

    // Emit to Server
    socket.emit("UPDATE", node.toMap());
    add(GraphZonedPeers());
  }

  // [User] is Available
  Stream<UserState> _mapNodeAvailableState(NodeAvailable event) async* {
    // Update Status
    node.status = Status.Available;

    // Emit to Server
    socket.emit("UPDATE", node.toMap());
    yield NodeAvailableInProgress(node);
  }

// [User] is Busy
  Stream<UserState> _mapNodeBusyState(NodeBusy event) async* {
    // Update Status
    node.status = Status.Busy;

    // Emit to Server
    socket.emit("UPDATE", node.toMap());
  }

  // [User] is Reset
  Stream<UserState> _mapNodeResetState(NodeReset event) async* {
    // Get Data
    var match = event.match;

    // Check if Match Provided
    if (match != null) {
      // Close Connection and DataChannel
      session.peerConnections[match.id].close();
      session.dataChannels[match.id].close();

      // Remove from Connection and DataChannel
      session.peerConnections.remove(match.id);
      session.dataChannels.remove(match.id);

      // Clear Session ID
      session.id = null;
    }
  }

  // [Peer] has Cancelled
  Stream<UserState> _mapNodeCancelState(NodeCancel event) async* {
    // Get Data
    var match = event.match;

    // Remove RTC Connection
    var pc = session.peerConnections[match.id];
    if (pc != null) {
      pc.close();
      session.peerConnections.remove(match.id);
    }

    // Remove DataChannels
    var dc = session.dataChannels[match.id];
    if (dc != null) {
      dc.close();
      session.dataChannels.remove(match.id);
    }

    // Reset Status
    session.updateState(SignalingState.CallStateBye);
  }

// ***************************
// ** Node Emitter - Sender **
// ***************************
// [User] Send Offer to another peer
  Stream<UserState> _mapNodeOfferedState(NodeOffered event) async* {
    // Change Session State
    session.id = node.id + '-' + event.to.id;
    session.updateState(SignalingState.CallStateNew);

    // Add Peer Connection
    RTCPeerConnection pc = await session.newPeerConnection(event.to.id, node);

    // Initialize RTC Sender Connection
    session.initializePeer(Role.Sender, pc, event.to);

    try {
      // Create Offer Description
      RTCSessionDescription s = await pc.createOffer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("OFFER", [
        node.toMap(),
        event.to.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.id,
          'metadata': event.file.metadata.toMap()
        }
      ]);
    } catch (e) {
      print(e.toString());
    }

    // Change Status
    add(NodeBusy());
    yield NodeRequestInProgress(event.to);
  }

  // [Peer] Authorized Offer
  Stream<UserState> _mapNodeAuthorizedState(NodeAuthorized event) async* {
    // Get Match Node
    var description = event.answer['description'];

    // Add Peer Connection
    var pc = session.peerConnections[event.match.id];
    if (pc != null) {
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));
    }

    yield NodeRequestFailure();
  }

  // [Peer] Rejected Offer
  Stream<UserState> _mapNodeRejectedState(NodeRejected event) async* {
    // Update Status
    add(NodeSearch());

    yield NodeRequestFailure();
  }

// *****************************
// ** Node Emitter - Receiver **
// *****************************
  // [Peer] Has Sent Request
  Stream<UserState> _mapNodeRequestedState(NodeRequested event) async* {
    // Change State
    yield NodeRequestInitial(event.from, event.offer, event.metadata);
  }

  // [User] Authorized Offer
  Stream<UserState> _mapNodeAcceptedState(NodeAccepted event) async* {
    // Get Data
    var offer = event.offer;
    var match = event.match;
    var metadata = event.metadata;

    // Update Signalling State
    session.id = offer['session_id'];
    session.updateState(SignalingState.CallStateNew);

    // Create Peer Connection
    var pc = await session.newPeerConnection(match.id, node);

    // Initialize RTC Receiver Connection
    session.initializePeer(Role.Receiver, pc, match,
        description: offer['description']);

    // Set Candidates
    await session.setRemoteCandidates(pc);

    // Emit Answer
    try {
      // Create Answer Description
      RTCSessionDescription s = await pc.createAnswer(RTC_CONSTRAINTS);
      pc.setLocalDescription(s);

      // Emit to Socket.io
      socket.emit("ANSWER", [
        node.toMap(),
        match.id,
        {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': session.id,
        }
      ]);
    } catch (e) {
      print(e.toString());
    }

    // Change Status
    add(NodeBusy());
    yield NodeTransferInitial(metadata, match);
  }

  // [Peer] Has Sent Candidate
  Stream<UserState> _mapNodeCandidateState(NodeCandidate event) async* {
    // Emit to Socket.io
    session.handleCandidate(event.match, event.candidate);
  }

// [User] Rejected Offer
  Stream<UserState> _mapNodeDeclinedState(NodeDeclined event) async* {
    // Emit to Socket.io
    socket.emit("DECLINE", [node.toMap(), event.to.id]);

    // Update Status
    add(NodeAvailable());
  }
}
