import 'package:equatable/equatable.dart';

abstract class SenderState extends Equatable {
  const SenderState();

  @override
  List<Object> get props => [];
}

// In Sender Position
class SenderReady extends SenderState {
  const SenderReady() : super();
}

// Msg Server Realtime
class SenderSearching extends SenderState {
  const SenderSearching() : super();
}

// Found Match
class SenderFound extends SenderState {
  const SenderFound() : super();
}

// Waiting for Authorization
class SenderPending extends SenderState {
  const SenderPending() : super();
}

// Transfer Finished
class SenderComplete extends SenderState {
  const SenderComplete() : super();
}

// User Cancelled
class SenderCancelled extends SenderState {
  const SenderCancelled() : super();
}

// Error Occurred: Server
class SenderError extends SenderState {
  const SenderError() : super();
}
