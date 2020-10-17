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
  const Update(this.newStatus);
}

// Receiver is Presented with Authorization
class Authorize extends WebEvent {
  final bool decision;
  final dynamic message;
  const Authorize(this.decision, this.message);
}

class End extends WebEvent {
  final EndType type;
  final Peer match;
  const End(this.type, {this.match});
}
