import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/controllers/controllers.dart';
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
class Initialize extends SonarEvent {
  const Initialize();
}

// Send to Server Sequence
class Send extends SonarEvent {
  final Direction newDirection;

  const Send(
      {
      @required this.newDirection});
}

// Receive to Server Sequence
class Receive extends SonarEvent {
  final Direction newDirection;

  const Receive(
      {
      @required this.newDirection});
}

// Receiver/Sender Compare Directions with Circle
class Compare extends SonarEvent {
  final Direction newDirection;

  const Compare(
      {
      @required this.newDirection});
}

// Tap Peer from List or Point to Receiver for 2s
class Select extends SonarEvent {
  final Client match;

    const Select(
      {
      @required this.match});
}

// Sender Requests Authorization
class Request extends SonarEvent {
  final Client match;

    const Request(
      {
      @required this.match});
}

// Receiver Offerred Sonar Transfer
class Offered extends SonarEvent {
  final bool decision;
  final Client sender;

  const Offered({@required this.sender, @required this.decision});
}

// Authentication Success
class StartTransfer extends SonarEvent {
  final Transfer transfer;

  const StartTransfer({@required this.transfer});
}

// Transfer Complete
class CompleteTransfer extends SonarEvent {
  final Transfer transfer;

  const CompleteTransfer({@required this.transfer});
}

// Cancel on Button Tap
class CancelSonar extends SonarEvent {
  const CancelSonar();
}

// On Cancel, On Done, On Zero
class ResetSonar extends SonarEvent {
  const ResetSonar();
}

// ***************************
// ** Subscription Events ****
// ***************************
// Device Position: Sender/Receiver/Zero BLoC State - Constantly Updated by Subscription
class UpdateSensors extends SonarEvent {
  final Direction direction;
  final Motion motion;

  const UpdateSensors({@required this.motion, @required this.direction});

  @override
  List<Object> get props => [direction, motion];
}

// Device Position: Sender/Receiver/Zero BLoC State - Constantly Updated by Subscription
class ReadMessage extends SonarEvent {
  final Message incomingMessage;

  const ReadMessage({@required this.incomingMessage});

  @override
  List<Object> get props => [incomingMessage];
}
