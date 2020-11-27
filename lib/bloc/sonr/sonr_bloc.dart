import 'dart:async';
import 'dart:io';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/utils.dart';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';

part 'sonr_event.dart';
part 'sonr_state.dart';

class SonrBloc extends Bloc<SonrEvent, SonrState> {
  // Subscription Properties
  Node node;
  LobbyCubit availablePeers = new LobbyCubit();
  ProgressCubit exchangeProgress = new ProgressCubit();

  // ^ Constructer Sets Callbacks ^ //
  SonrBloc() : super(NodeOffline());

  // ^ Map Events to Function ^ //
  @override
  Stream<SonrState> mapEventToState(
    SonrEvent event,
  ) async* {
    if (event is NodeInitialize) {
      yield* _mapNodeInitializeState(event);
    } else if (event is NodeCancel) {
      yield* _mapNodeCancelState(event);
    } else if (event is NodeSearch) {
      yield* _mapNodeSearchState(event);
    } else if (event is NodeQueueFile) {
      yield* _mapNodeQueueFileState(event);
    } else if (event is NodeInvitePeer) {
      yield* _mapNodeInvitePeerState(event);
    } else if (event is NodeRespondPeer) {
      yield* _mapNodeRespondPeerState(event);
    }
  }

  // **************************
  // ** Event Based Handlers **
  // **************************
  // ^ NodeInitialize Event ^
  Stream<SonrState> _mapNodeInitializeState(NodeInitialize event) async* {
    // Get OLC
    var olcCode = OLC.encode(event.position.latitude, event.position.longitude,
        codeLength: 8);

    // Await Initialization
    node = await SonrCore.initialize(olcCode, event.contact);

    // Assign Node Callbacks
    node.assignCallback(CallbackEvent.Refreshed, handleRefreshed);
    node.assignCallback(CallbackEvent.Queued, handleQueued);
    node.assignCallback(CallbackEvent.Invited, handleInvited);
    node.assignCallback(CallbackEvent.Accepted, handleAccepted);
    node.assignCallback(CallbackEvent.Denied, handleDenied);
    node.assignCallback(CallbackEvent.Progressed, handleProgressed);
    node.assignCallback(CallbackEvent.Completed, handleCompleted);
    node.assignCallback(CallbackEvent.Error, handleSonrError);
    yield NodeAvailable();
  }

  // ^ NodeQueueFile Event ^
  Stream<SonrState> _mapNodeQueueFileState(NodeQueueFile event) async* {
    node.queue(event.file.path);
    yield NodeQueueing();
  }

  // ^ NodeSearch Event ^
  Stream<SonrState> _mapNodeSearchState(NodeSearch event) async* {
    yield NodeSearching();
  }

  // ^ NodeCancel Event: Cancel Current Process and Change State to Available ^
  Stream<SonrState> _mapNodeCancelState(NodeCancel event) async* {
    yield NodeAvailable();
  }

  // ^ NodeInvitePeer Event ^
  Stream<SonrState> _mapNodeInvitePeerState(NodeInvitePeer event) async* {
    node.invite(event.peer);
    yield PeerInvited(event.peer);
  }

  // ^ NodeRespondPeer Event ^
  Stream<SonrState> _mapNodeRespondPeerState(NodeRespondPeer event) async* {
    // @ Send Response
    node.respond(event.decision);

    // @ Update State by Decision
    if (event.decision) {
      // Update State to Accepted
      yield NodeReceiveInProgress(event.peer, event.metadata);
    } else {
      // Update State to Declined
      yield NodeAvailable();
    }
  }

  // *****************************
  // ** Callback Based Handlers **
  // *****************************
  // ^ Lobby Has Been Updated ^ //
  void handleRefreshed(dynamic data) async {
    // Check Type
    if (data is Lobby) {
      availablePeers.update(data);
    }
  }

// ^ Node Has Been Invited ^ //
  Stream<SonrState> handleInvited(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      print(data.toProto3Json());
      // Verify Event
      if (data.event == AuthMessage_Event.REQUEST) {
        yield NodeInvited(data.from, data.metadata);
      }
    }
  }

  // ^ Node Has Been Denied ^ //
  Stream<SonrState> handleAccepted(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      print(data.toProto3Json());
      // Verify Event
      if (data.event == AuthMessage_Event.ACCEPT) {
        node.transfer();
        yield NodeTransferInProgress(data.from);
      }
    }
  }

// ^ Node Has Been Denied ^ //
  Stream<SonrState> handleDenied(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      print(data.toProto3Json());
      // Verify Event
      if (data.event == AuthMessage_Event.DECLINE) {
        yield PeerInviteDeclined(data.from);
      }
    }
  }

  // ^ Transfer Has Succesfully Completed ^ //
  Stream<SonrState> handleCompleted(dynamic data) async* {
    if (data is Metadata) {
      print(data.toProto3Json());
      // Check what current state is
      if (this.state is NodeTransferInProgress) {
      } else if (this.state is NodeReceiveInProgress) {}
      yield NodeAvailable();
    }
  }

// ^ An Error Has Occurred ^ //
  Stream<SonrState> handleSonrError(dynamic data) async* {
    if (data is ErrorMessage) {
      print(data.toProto3Json());
    }
  }

// **************************
// ** Responsive Handlers  **
// **************************
// ^ File has Succesfully Queued ^ //
  Stream<SonrState> handleQueued(dynamic data) async* {
    if (data is Metadata) {
      print(data.toProto3Json());
      add(NodeSearch());
    }
  }

// ^ Transfer Has Updated Progress ^ //
  void handleProgressed(dynamic data) async {
    if (data is ProgressMessage) {
      print(data.toProto3Json());
      exchangeProgress.update(data.progress);
    }
  }
}
