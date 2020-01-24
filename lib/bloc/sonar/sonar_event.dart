import 'package:equatable/equatable.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {}

// Device Position BLoC State
class SetZero extends SonarEvent {}

// Device Position BLoC State
class SetSender extends SonarEvent {}

// Device Position BLoC State
class SetReceiver extends SonarEvent {}

// Approve Authentication
class Approve extends SonarEvent {}

// Decline Authentication
class Decline extends SonarEvent {}

// Cancel Sequence
class Cancel extends SonarEvent {}

// Process Complete
class Done extends SonarEvent {}