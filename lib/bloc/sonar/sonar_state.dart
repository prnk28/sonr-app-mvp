import 'package:equatable/equatable.dart';

abstract class SonarState extends Equatable {
  const SonarState();

  @override
  List<Object> get props => [];
}

// Preload State
class Initial extends SonarState {
  const Initial() : super();
}

// Connected to Lobby/WS
class Ready extends SonarState {
  const Ready() : super();
}

// In Sending Position
class Sending extends SonarState {
  const Sending() : super();
}

// In Receiving Position
class Receiving extends SonarState {
  const Receiving() : super();
}

// Found Match
class Found extends SonarState {
  const Found() : super();
}

// Pending Transfer Confirmation
class Authenticating extends SonarState {
  const Authenticating() : super();
}

// In WebRTC Transfer or Contact Transfer
class Transferring extends SonarState {
  const Transferring() : super();
}

// Transfer Succesful
class Complete extends SonarState {
  const Complete() : super();
}

// Failed Sonar: Cancel/Decline/Error
class Failed extends SonarState {
  const Failed() : super();
}
