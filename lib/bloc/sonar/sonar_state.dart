import 'package:equatable/equatable.dart';
import 'package:sonar_app/controllers/controllers.dart';

abstract class SonarState extends Equatable {
  const SonarState();

  @override
  List<Object> get props => [];
}

// Preload State
class Initial extends SonarState {
  const Initial();
}

// Connected to Lobby/WS
class Ready extends SonarState {
  final Process runningProcess;
  const Ready(this.runningProcess);
}

// In Sending Position
class Sending extends SonarState {
  final Process runningProcess;
  const Sending(this.runningProcess);
}

// In Receiving Position
class Receiving extends SonarState {
  final Process runningProcess;
  const Receiving(this.runningProcess);
}

// Found Match: Either Select or AutoSelect
class Found extends SonarState {
  final Process runningProcess;
  const Found(this.runningProcess);
}

// Pending Transfer Confirmation
class Authenticating extends SonarState {
  final Process runningProcess;
  const Authenticating(this.runningProcess);
}

// In WebRTC Transfer or Contact Transfer
class Transferring extends SonarState {
  final Process runningProcess;
  const Transferring(this.runningProcess);
}

// Transfer Succesful
class Complete extends SonarState {
  final Process runningProcess;
  const Complete(this.runningProcess);
}

// Failed Sonar: Cancel/Decline/Error
class Failed extends SonarState {
  final Process runningProcess;
  const Failed(this.runningProcess);
}
