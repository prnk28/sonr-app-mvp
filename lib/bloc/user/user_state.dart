part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

// User cannot communicate to server
class UserLoadFailure extends UserState {
  UserLoadFailure();
}

// User can communicate to server
class UserLoadSuccess extends UserState {
  final Peer user;

  UserLoadSuccess(this.user);
}
