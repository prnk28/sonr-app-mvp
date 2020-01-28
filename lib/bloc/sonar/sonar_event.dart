import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {}

// Device Position: Sender/Receiver/Zero BLoC State
class UpdatePosition extends SonarEvent {
    final String newPosition;

  const UpdatePosition({@required this.newPosition});

   @override
  List<Object> get props => [newPosition];
}

// Approve/Decline Authentication
class SetAuthentication extends SonarEvent {
  final String authentication;

  const SetAuthentication({@required this.authentication});

   @override
  List<Object> get props => [authentication];
}

// Cancel Sequence
class Cancel extends SonarEvent {}

// Process Complete
class Done extends SonarEvent {}