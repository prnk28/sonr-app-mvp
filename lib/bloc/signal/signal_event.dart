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

// Sequence Finished
class End extends SignalEvent {
  final EndType type;
  final Peer match;
  final SonrFile file;
  const End(this.type, {this.match, this.file});
}
