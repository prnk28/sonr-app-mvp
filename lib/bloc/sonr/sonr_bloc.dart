import 'dart:async';
import 'dart:io';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/utils.dart';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:equatable/equatable.dart';
// import 'package:graph_collection/graph.dart';

part 'sonr_callback.dart';
part 'sonr_event.dart';
part 'sonr_peers.dart';
part 'sonr_state.dart';

class SonrBloc extends Bloc<SonrEvent, SonrState> {
  // Subscription Properties
  Node node;
  TransferProgress progress;

  // ^ Constructer Sets Callbacks ^ //
  SonrBloc() : super(NodeOffline()) {
    node.assignCallback(CallbackEvent.Refreshed, handleRefreshed);
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
    } else if (event is NodeQueueFile) {
      yield* _mapNodeQueueFileState(event);
    } else if (event is NodeInvitePeer) {
      yield* _mapNodeInvitePeerState(event);
    } else if (event is NodeRespondPeer) {
      yield* _mapNodeRespondPeerState(event);
    } else if (event is NodeTransfer) {
      yield* _mapNodeTransferState(event);
    }
  }

  // **************************
  // ** NodeInitialize Event **
  // **************************
  Stream<SonrState> _mapNodeInitializeState(NodeInitialize event) async* {
    // Get OLC
    var olcCode = OLC.encode(event.position.latitude, event.position.longitude);

    // Await Initialization
    node = await SonrCore.initialize(olcCode, event.contact);
  }

  // **********************
  // ** NodeUpdate Event **
  // **********************
  Stream<SonrState> _mapNodeUpdateState(NodeUpdate event) async* {
    node.update(event.newDirection);
  }

  // *************************
  // ** NodeQueueFile Event **
  // *************************
  Stream<SonrState> _mapNodeQueueFileState(NodeQueueFile event) async* {
    node.queue(event.file.path);
  }

  // *************************
  // ** NodeQueueFile Event **
  // *************************
  Stream<SonrState> _mapNodeInvitePeerState(NodeInvitePeer event) async* {
    node.invite(event.peer);
  }

  // *************************
  // ** NodeQueueFile Event **
  // *************************
  Stream<SonrState> _mapNodeRespondPeerState(NodeRespondPeer event) async* {
    node.respond(event.decision);
  }

  // *************************
  // ** NodeQueueFile Event **
  // *************************
  Stream<SonrState> _mapNodeTransferState(NodeTransfer event) async* {
    node.transfer();
  }
}
