part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

// User cannot communicate to server
class Offline extends UserState {
  Offline();
}

// User can communicate to server
class Online extends UserState {
  final Profile profile;

  Online(this.profile);
}

// User is matched with a peer
class Paired extends UserState {
  final Peer match;
  final RTCPeerConnection peerConnection;

  Paired(this.match, this.peerConnection);
}

class Unregistered extends UserState {
  Unregistered();
}

class Waiting extends UserState {
  Waiting();
}
