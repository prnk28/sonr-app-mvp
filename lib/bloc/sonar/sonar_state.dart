import 'package:equatable/equatable.dart';
import 'package:sonar_app/controllers/controllers.dart';

abstract class SonarState extends Equatable {
  final Process runningProcess;
  
  const SonarState(this.runningProcess);

  @override
  List<Object> get props => [];
}

// Preload State
class Initial extends SonarState {
  const Initial(Process runningProcess) : super(runningProcess);
}

// Connected to Lobby/WS
class Ready extends SonarState {
  const Ready(Process runningProcess) : super(runningProcess);
}

// In Sending Position
class Sending extends SonarState {
  const Sending(Process runningProcess) : super(runningProcess);
}

// In Receiving Position
class Receiving extends SonarState {
  const Receiving(Process runningProcess) : super(runningProcess);
}

// Found Match: Either Select or AutoSelect
class Found extends SonarState {
  const Found(Process runningProcess) : super(runningProcess);
}

// Pending Transfer Confirmation
class Authenticating extends SonarState {
  const Authenticating(Process runningProcess) : super(runningProcess);
}

// In WebRTC Transfer or Contact Transfer
class Transferring extends SonarState {
  const Transferring(Process runningProcess) : super(runningProcess);
}

// Transfer Succesful
class Complete extends SonarState {
  const Complete(Process runningProcess) : super(runningProcess);
}

// Failed Sonar: Cancel/Decline/Error
class Failed extends SonarState {
  const Failed(Process runningProcess) : super(runningProcess);
}
