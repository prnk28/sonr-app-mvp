import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/controllers/process.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/models/transfer.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {}

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
class AutoSelect extends SonarEvent {}

// Tap Peer from List
class Select extends SonarEvent {}

// Sender Requests Authorization
class Request extends SonarEvent {
  final Client match;

  const Request({@required this.match});

  @override
  List<Object> get props => [match];
}

// Receiver Offerred Sonar Transfer
class Offered extends SonarEvent {
  final bool decision;
  final Client sender;

  const Offered({@required this.sender, @required this.decision});

  @override
  List<Object> get props => [sender, decision];
}

// Authentication Success
class StartTransfer extends SonarEvent {
  final Transfer transfer;

  const StartTransfer({@required this.transfer});

  @override
  List<Object> get props => [transfer];
}

// Transfer Complete
class CompleteTransfer extends SonarEvent {
  final Transfer transfer;

  const CompleteTransfer({@required this.transfer});

  @override
  List<Object> get props => [transfer];
}

// Cancel on Button Tap
class CancelSonar extends SonarEvent {
  final Process runningProcess;

  const CancelSonar({@required this.runningProcess});

  @override
  List<Object> get props => [runningProcess];
}

// On Cancel, On Done, On Zero
class ResetSonar extends SonarEvent {
  final Process runningProcess;

  const ResetSonar({@required this.runningProcess});

  @override
  List<Object> get props => [runningProcess];
}

// ***************************
// ** Subscription Events ****
// ***************************
// Device Position: Sender/Receiver/Zero BLoC State - Constantly Updated by Subscription
class UpdateOrientation extends SonarEvent {
  final Motion newPosition;

  const UpdateOrientation({@required this.newPosition});

  @override
  List<Object> get props => [newPosition];
}

// Device Position: Sender/Receiver/Zero BLoC State - Constantly Updated by Subscription
class ReadMessage extends SonarEvent {
  final Message incomingMessage;

  const ReadMessage({@required this.incomingMessage});

  @override
  List<Object> get props => [incomingMessage];
}
