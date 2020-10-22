part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

// No Profile Found
class ProfileLoadFailure extends UserState {
  ProfileLoadFailure();
}

// Profile has been found
class ProfileLoadSuccess extends UserState {
  final Peer user;

  ProfileLoadSuccess(this.user);
}
