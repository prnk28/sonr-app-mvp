import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

abstract class MotionState extends Equatable {
  final Motion position;

  const MotionState(this.position);

   @override
  List<Object> get props => [];
}

// Device in Default Position
class Zero extends MotionState {
  const Zero(Motion position) : super(position);
}

// Device in Motion
class Shift extends MotionState {
  const Shift(Motion position) : super(position);
}

// Device in Tilted Y-Threshold
class Send extends MotionState {
  const Send(Motion position) : super(position);
}

// Device in Landscape Mode
class Receive extends MotionState {
  const Receive(Motion position) : super(position);
}

// Device in Transfer Suspend Motion
class Suspend extends MotionState {
  final MotionState lastState;
  const Suspend(Motion position, this.lastState) : super(position);
}