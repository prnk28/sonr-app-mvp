part of 'web_bloc.dart';

enum EndType {
  Cancel,
  Complete,
  Exit,
  Fail,
}

abstract class WebEvent extends Equatable {
  const WebEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to WS, Join/Create Lobby
class Connect extends WebEvent {
  const Connect();
}

// Between Server Reads
class Load extends WebEvent {
  const Load();
}

// Send Node Data
class Update extends WebEvent {
  final Status newStatus;
  final double newDirection;
  final Peer match;
  final Metadata metadata;
  final dynamic offer;

  const Update(this.newStatus,
      {this.newDirection,
      this.match,
      this.metadata,
      this.offer});
}

// Receiver is Presented with Authorization
class Authorize extends WebEvent {
  final bool decision;
  final Peer match;
  final dynamic offer;
  const Authorize(this.decision, this.match, this.offer);
}

class End extends WebEvent {
  final EndType type;
  final Peer match;
  const End(this.type, {this.match});
}
