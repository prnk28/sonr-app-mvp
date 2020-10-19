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
  // Status Variables
  final Status newStatus;
  final double newDirection;

  // User Variables
  final Peer from;
  final Metadata metadata;
  final bool decision;

  // RTC Variables
  final dynamic offer;
  final dynamic answer;

  const Update(this.newStatus,
      {this.newDirection,
      this.from,
      this.metadata,
      this.offer,
      this.answer,
      this.decision});
}

class End extends WebEvent {
  final EndType type;
  final Peer match;
  const End(this.type, {this.match});
}
