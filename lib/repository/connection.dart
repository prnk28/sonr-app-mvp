import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'dart:io' show Platform;
import 'repository.dart';

class Connection {
  WebBloc web;
  UserBloc user;

  Connection(this.web, this.user) {
    // ***************************** //
    // ** Socket Message Listener ** //
    // ***************************** //
    // -- USER CONNECTED TO SOCKET SERVER --
    socket.on('CONNECTED', (data) {
      // Set Lobby Id
      user.node.lobbyId = data["lobbyId"];
      // Update Beacon Settings
      web.add(Handle(MessageKind.CONNECTED));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      Peer peer = Peer.fromMap(data);
      log.i("Update Node");
      web.add(Update(UpdateType.GRAPH,
          graphUpdate: GraphUpdate.UPDATE, peer: peer));
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      Peer peer = Peer.fromMap(data);
      web.add(
          Update(UpdateType.GRAPH, graphUpdate: GraphUpdate.EXIT, peer: peer));
    });

    // -- OFFER REQUEST --
    socket.on('PEER_OFFERED', (data) {
      log.i(data.toString());
      web.add(Handle(MessageKind.OFFER,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('PEER_ANSWERED', (data) {
      log.i(data.toString());
      web.add(Handle(MessageKind.ANSWER,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('PEER_DECLINED', (data) {
      log.i(data.toString());
      web.add(Handle(MessageKind.DECLINED));
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('PEER_CANDIDATE', (data) {
      log.i(data.toString());
      session.handleCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETE', (data) {
      log.i(data.toString());
      web.add(Handle(MessageKind.COMPLETE,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });
  }
}
