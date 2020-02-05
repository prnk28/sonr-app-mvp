import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

abstract class OrientationState extends Equatable {
  final Motion position;

  const OrientationState(this.position);

   @override
  List<Object> get props => [];
}

// Device in Default Position
class Default extends OrientationState {
  const Default(Motion position) : super(position);
}

// Device in Motion
class Shifting extends OrientationState {
  const Shifting(Motion position) : super(position);
}

// Device in Tilted Y-Threshold/ Sending Mode
class Tilted extends OrientationState {
  const Tilted(Motion position) : super(position);
}

// Device in Receiving Mode/ Landscape
class Landscaped extends OrientationState {
  const Landscaped(Motion position) : super(position);
}

// Device in Transfer Suspend Motion
class Suspended extends OrientationState {
  final OrientationState lastState;
  const Suspended(Motion position, this.lastState) : super(position);
}