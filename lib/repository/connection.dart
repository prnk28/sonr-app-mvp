import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
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
      user.node.id = socket.id;
      log.i(socket.id.toString());
      
    });

    // -- NODE APPEARED IN LOBBY --
    socket.on('NODE_ENTER', (data) {
      Peer peer = Peer.fromMap(data);
      log.i(data.toString());
      web.add(UpdateGraph(GraphUpdate.ENTER, peer));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      Peer peer = Peer.fromMap(data);
      web.add(UpdateGraph(GraphUpdate.UPDATE, peer));
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      Peer peer = Peer.fromMap(data);
      web.add(UpdateGraph(GraphUpdate.EXIT, peer));
    });

    // -- OFFER REQUEST --
    socket.on('PEER_OFFERED', (data) {
      web.add(Handle(HandleType.OFFER,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('PEER_ANSWERED', (data) {
      web.add(Handle(HandleType.ANSWER,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('PEER_DECLINED', (data) {
      web.add(Handle(HandleType.DECLINED));
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('PEER_CANDIDATE', (data) {
      session.handleCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETE', (data) {
      web.add(Handle(HandleType.COMPLETE,
          match: Peer.fromMap(data["from"]), message: data));
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
    });
  }
}
