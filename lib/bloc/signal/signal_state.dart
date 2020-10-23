part of 'signal_bloc.dart';

abstract class SignalState extends Equatable {
  const SignalState();
  @override
  List<Object> get props => [];
}

//** Pre Socket Connection **/
class SocketInitial extends SignalState {
  const SocketInitial();
}

//** Socket Initialized **/
class SocketSuccess extends SignalState {
  const SocketSuccess();
}

//** Socket Failed to Connect **/
class SocketFailure extends SignalState {
  const SocketFailure();
}
