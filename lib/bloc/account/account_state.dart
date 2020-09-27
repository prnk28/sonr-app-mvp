part of 'account_bloc.dart';

enum AccountBlocStatus {
  Offline,
  Online,
  Unregistered,
  Waiting,
}

abstract class AccountState extends Equatable {
  const AccountState({this.status});
  final AccountBlocStatus status;
  @override
  List<Object> get props => [];
}

class Offline extends AccountState {
  Offline({status: AccountBlocStatus.Offline});
}

class Online extends AccountState {
  final Profile profile;

  Online(this.profile, {status: AccountBlocStatus.Online});
}

class Unregistered extends AccountState {
  Unregistered({status: AccountBlocStatus.Unregistered});
}

class Waiting extends AccountState {
  Waiting({status: AccountBlocStatus.Waiting});
}
