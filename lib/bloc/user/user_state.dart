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
  final Peer user;

  Online(this.user);
}

class Unregistered extends UserState {
  Unregistered();
}

class Waiting extends UserState {
  Waiting();
}
