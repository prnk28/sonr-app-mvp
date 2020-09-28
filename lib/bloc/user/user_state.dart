part of 'user_bloc.dart';

enum UserBlocStatus {
  Offline,
  Online,
  Unregistered,
  Waiting,
}

abstract class UserState extends Equatable {
  const UserState({this.status});
  final UserBlocStatus status;
  @override
  List<Object> get props => [];
}

class Offline extends UserState {
  Offline({status: UserBlocStatus.Offline});
}

class Online extends UserState {
  final Profile profile;

  Online(this.profile, {status: UserBlocStatus.Online});
}

class Unregistered extends UserState {
  Unregistered({status: UserBlocStatus.Unregistered});
}

class Waiting extends UserState {
  Waiting({status: UserBlocStatus.Waiting});
}
