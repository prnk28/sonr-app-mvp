import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/models/models.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {}

// Device Position: Sender/Receiver/Zero BLoC State - Constantly Updated by Subscription
class ShiftMotion extends SonarEvent {
  final Motion newPosition;

  const ShiftMotion({@required this.newPosition});

  @override
  List<Object> get props => [newPosition];
}

// Approve/Decline Authentication
class Authenticate extends SonarEvent {
  final String authentication;

  const Authenticate({@required this.authentication});

  @override
  List<Object> get props => [authentication];
}

// Send to Server Sequence
class Send extends SonarEvent {
  final Client user;
  final Lobby connectedLobby;
  final Direction newDirection;

  const Send(
      {@required this.user,
      @required this.connectedLobby,
      @required this.newDirection});

  @override
  List<Object> get props => [user, connectedLobby, newDirection];
}

// Receive to Server Sequence
class Receive extends SonarEvent {
  final Client user;
  final Lobby connectedLobby;
  final Direction newDirection;

  const Receive(
      {@required this.user,
      @required this.connectedLobby,
      @required this.newDirection});

  @override
  List<Object> get props => [user, connectedLobby, newDirection];
}

// Point to Receiver for 2s
class Match extends SonarEvent {}

// Tap Peer from List
class Select extends SonarEvent {}

// Receiver Chosen
class Offered extends SonarEvent {}

// Authentication Success
class Transfer extends SonarEvent {}

// Transfer Complete
class Done extends SonarEvent {}

// Cancel on Button Tap
class Cancel extends SonarEvent {}

// On Cancel, On Done, On Zero
class Reset extends SonarEvent {}
