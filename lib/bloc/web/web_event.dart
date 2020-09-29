part of 'web_bloc.dart';

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
  final Profile userProfile;
  const Connect({this.userProfile});
}

// Send to Server Sequence
class Select extends WebEvent {
  final File file;

  const Select({this.file});
}

// Send to Server Sequence
class Send extends WebEvent {
  final Circle map;

  const Send({this.map});
}

// Receive to Server Sequence
class Receive extends WebEvent {
  final Circle map;

  const Receive({this.map});
}

// Send Peer Data to Socket.io
class EmitPeer extends WebEvent {
  final Peer peer;
  const EmitPeer({this.peer});
}

// Sender Invites Authorization
class Invite extends WebEvent {
  final String id;
  const Invite(this.id);
}

// Receiver Gets Authorization Request
class Offered extends WebEvent {
  final dynamic offer;
  final dynamic profile;
  const Offered({this.offer, this.profile});
}

// Receiver Gets Authorization Request
class Authorize extends WebEvent {
  final bool decision;
  final String matchId;
  final dynamic offer;
  const Authorize(this.decision, this.matchId, this.offer);
}

// Receiver has Accepted
class Accepted extends WebEvent {
  final dynamic profile;
  final dynamic answer;
  final String matchId;
  const Accepted(this.profile, this.matchId, this.answer);
}

// Receiver has Declined
class Declined extends WebEvent {
  final String matchId;
  final dynamic profile;
  const Declined(this.profile, this.matchId);
}

// Sender Begins Transfer
class Transfer extends WebEvent {
  const Transfer();
}

// Sender Sent Transfer
class Received extends WebEvent {
  final File data;
  const Received(this.data);
}

// On Transfer Complete
class Completed extends WebEvent {
  final String matchId;
  final dynamic profile;
  const Completed(this.profile, this.matchId);
}

// Reset UI
class Reset extends WebEvent {
  final int secondDelay;
  const Reset(this.secondDelay);
}

// Update Sensory Input
class Reload extends WebEvent {
  final Direction newDirection;

  Reload({this.newDirection});
}

// Update Event
class Update extends WebEvent {
  final Circle map;
  final Motion currentMotion;
  final Direction currentDirection;

  const Update({this.map, this.currentDirection, this.currentMotion});
}
