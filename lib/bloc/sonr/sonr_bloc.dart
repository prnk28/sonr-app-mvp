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
  AvailablePeers availablePeers;
  FileQueue fileQueue;
  ExchangeProgress exchangeProgress;

  // ^ Constructer Sets Callbacks ^ //
  SonrBloc() : super(NodeOffline()) {
    node.assignCallback(CallbackEvent.Refreshed, handleRefreshed);
    node.assignCallback(CallbackEvent.Queued, handleQueued);
    node.assignCallback(CallbackEvent.Invited, handleInvited);
    node.assignCallback(CallbackEvent.Accepted, handleAccepted);
    node.assignCallback(CallbackEvent.Denied, handleDenied);
    node.assignCallback(CallbackEvent.Progressed, handleProgressed);
    node.assignCallback(CallbackEvent.Completed, handleCompleted);
    node.assignCallback(CallbackEvent.Error, handleSonrError);
  }

  // ^ Map Events to Function ^ //
  @override
  Stream<SonrState> mapEventToState(
    SonrEvent event,
  ) async* {
    if (event is NodeInitialize) {
      yield* _mapNodeInitializeState(event);
    } else if (event is NodeUpdate) {
      yield* _mapNodeUpdateState(event);
    } else if (event is NodeSearchN) {
      yield* _mapNodeSearchState(event);
    } else if (event is NodeQueueFile) {
      yield* _mapNodeQueueFileState(event);
    } else if (event is NodeInvitePeer) {
      yield* _mapNodeInvitePeerState(event);
    } else if (event is NodeRespondPeer) {
      yield* _mapNodeRespondPeerState(event);
    }
    // } else if (event is NodeTransfer) {
    //   yield* _mapNodeTransferState(event);
    // }
  }

  // **************************
  // ** Event Based Handlers **
  // **************************
  // ^ NodeInitialize Event ^
  Stream<SonrState> _mapNodeInitializeState(NodeInitialize event) async* {
    // Get OLC
    var olcCode = OLC.encode(event.position.latitude, event.position.longitude);

    // Await Initialization
    node = await SonrCore.initialize(olcCode, event.contact);
    yield NodeAvailableN();
  }

  // ^ NodeUpdate Event ^
  Stream<SonrState> _mapNodeUpdateState(NodeUpdate event) async* {
    node.update(event.newDirection);
  }

  // ^ NodeQueueFile Event ^
  Stream<SonrState> _mapNodeQueueFileState(NodeQueueFile event) async* {
    node.queue(event.file.path);
    yield NodeQueueing();
  }

  // ^ NodeSearch Event ^
  Stream<SonrState> _mapNodeSearchState(NodeSearchN event) async* {
    yield NodeSearchingN();
  }

  // ^ NodeInvitePeer Event ^
  Stream<SonrState> _mapNodeInvitePeerState(NodeInvitePeer event) async* {
    node.invite(event.peer);
    yield NodeRequestInProgressN(event.peer);
  }

  // ^ NodeRespondPeer Event ^
  Stream<SonrState> _mapNodeRespondPeerState(NodeRespondPeer event) async* {
    // @ Send Response
    node.respond(event.decision);

    // @ Update State by Decision
    if (event.decision) {
      // Update State to Accepted
      yield NodeReceiveInProgressN(event.peer);
    } else {
      // Update State to Declined
      yield NodeAvailableN();
    }
  }

  // *****************************
  // ** Callback Based Handlers **
  // *****************************
  // ^ Lobby Has Been Updated ^ //
  void handleRefreshed(dynamic data) async {
    // Check Type
    if (data is Lobby) {
      availablePeers.update(data.peers.values.toList());
    }
  }

// ^ Node Has Been Invited ^ //
  Stream<SonrState> handleInvited(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      // Verify Event
      if (data.event == AuthMessage_Event.REQUEST) {
        yield NodeInvited(data.from);
      }
    }
  }

  // ^ Node Has Been Denied ^ //
  Stream<SonrState> handleAccepted(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      // Verify Event
      if (data.event == AuthMessage_Event.ACCEPT) {
        node.transfer();
        yield NodeTransferInProgressN(data.from);
      }
    }
  }

// ^ Node Has Been Denied ^ //
  Stream<SonrState> handleDenied(dynamic data) async* {
    // Check Type
    if (data is AuthMessage) {
      // Verify Event
      if (data.event == AuthMessage_Event.DECLINE) {
        yield NodeRequestFailureN(data.from);
      }
    }
  }

// **************************
// ** Responsive Handlers  **
// **************************
// ^ File has Succesfully Queued ^ //
  void handleQueued(dynamic data) async {
    if (data is Metadata) {
      fileQueue.update(data);
    }
  }

// ^ Transfer Has Updated Progress ^ //
  void handleProgressed(dynamic data) async {
    if (data is ProgressMessage) {
      exchangeProgress.update(data.progress);
    }
  }

// ^ Transfer Has Succesfully Completed ^ //
  void handleCompleted(dynamic data) async {
    if (data is CompletedMessage) {
      
    }
  }

// ^ An Error Has Occurred ^ //
  void handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {

    }
  }
}
