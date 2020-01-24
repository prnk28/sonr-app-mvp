import 'package:equatable/equatable.dart';

abstract class SonarState extends Equatable {
  const SonarState();

  @override
  List<Object> get props => [];
}

// Preload State
class Default extends SonarState {
  const Default() : super();
}

// Connected to Lobby/Network Post Initialize
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

// Pending Confirmation
class Authenticating extends SonarState {
  const Authenticating() : super();
}

// In Sending/Receiving Position
class Transfering extends SonarState {
  const Transfering() : super();
}

// Transfer Succesful
class Complete extends SonarState {
  const Complete() : super();
}

// Failed Sonar: Cancel/Decline/Error
class Failed extends SonarState {
  const Failed() : super();
}
