import 'package:equatable/equatable.dart';

abstract class ReceiverState extends Equatable {
  const ReceiverState();

  @override
  List<Object> get props => [];
}

// In Receiver Position
class ReceiverReady extends ReceiverState {
  const ReceiverReady() : super();
}

// Msg Server Realtime
class ReceiverSearching extends ReceiverState {
  const ReceiverSearching() : super();
}

// Found Match
class ReceiverFound extends ReceiverState {
  const ReceiverFound() : super();
}

// Waiting for Authorization
class ReceiverPending extends ReceiverState {
  const ReceiverPending() : super();
}

// Transfer Finished
class ReceiverComplete extends ReceiverState {
  const ReceiverComplete() : super();
}

// User Cancelled
class ReceiverCancelled extends ReceiverState {
  const ReceiverCancelled() : super();
}

// Error Occurred: Server
class ReceiverError extends ReceiverState {
  const ReceiverError() : super();
}
