import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SenderEvent extends Equatable {
  const SenderEvent();

  @override
  List<Object> get props => [];
}

// Send Process Start
class SenderStart extends SenderEvent {}

// WS Recursive Call, Direction Too
class SenderLook extends SenderEvent {}

// Sonar Auto Select
class SenderMatch extends SenderEvent {}

// Choose from Peer Circle
class SenderSelect extends SenderEvent {}

// Either Transfer Complete/ Error/ or Cancelled
class SenderDone extends SenderEvent {}