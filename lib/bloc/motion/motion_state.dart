import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

abstract class MotionState extends Equatable {
  final Motion position;

  const MotionState(this.position);

   @override
  List<Object> get props => [];
}

// Device in Default Position
class Default extends MotionState {
  const Default(Motion position) : super(position);
}

// Device in Motion
class Shifting extends MotionState {
  const Shifting(Motion position) : super(position);
}

// Device in Tilted Y-Threshold/ Sending Mode
class Tilted extends MotionState {
  const Tilted(Motion position) : super(position);
}

// Device in Receiving Mode/ Landscape
class Landscaped extends MotionState {
  const Landscaped(Motion position) : super(position);
}

// Device in Transfer Suspend Motion
class Suspended extends MotionState {
  final MotionState lastState;
  const Suspended(Motion position, this.lastState) : super(position);
}