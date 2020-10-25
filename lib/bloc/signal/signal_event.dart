part of 'signal_bloc.dart';

enum EndType {
  Cancel,
  Complete,
  Exit,
  Fail,
}

abstract class SignalEvent extends Equatable {
  const SignalEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to Socket
class SocketStarted extends SignalEvent {
  const SocketStarted();
}

class PeerInvited extends SignalEvent {
  final Node match;
  final String sessionId;
  final RTCPeerConnection pc;
  final Metadata metadata;

  PeerInvited(this.match, this.sessionId, this.pc, this.metadata);
}

class PeerAnswered extends SignalEvent {
  final Node match;
  final String sessionId;
  final RTCPeerConnection pc;

  PeerAnswered(this.match, this.sessionId, this.pc);
}

// Sequence Finished
class End extends SignalEvent {
  final EndType type;
  final Node match;
  final SonrFile file;
  const End(this.type, {this.match, this.file});
}
