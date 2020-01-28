import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ReceiverEvent extends Equatable {
  const ReceiverEvent();

  @override
  List<Object> get props => [];
}

// Receive Process Start
class ReceiverStart extends ReceiverEvent {}

// WS Recursive Call, Direction Too
class ReceiverLook extends ReceiverEvent {}

// Sonar Auto Select
class ReceiverMatch extends ReceiverEvent {}

// Choose from Peer Circle
class ReceiverSelect extends ReceiverEvent {}

// Either Transfer Complete/ Error/ or Cancelled
class ReceiverDone extends ReceiverEvent {}