import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

abstract class SensorState extends Equatable {
  const SensorState();

  @override
  List<Object> get props => [];
}

// Evaluating Directions
class Loading extends SensorState {
  const Loading();
}

// Device in Motion
class Default extends SensorState {
  final Motion motion;
  const Default({this.motion});
}

// Device in Tilted Y-Threshold/ Sending Mode
class Tilted extends SensorState {
  final Motion motion;
  final Direction direction;
  const Tilted({this.motion, this.direction});
}

// Device in Receiving Mode/ Landscape
class Landscaped extends SensorState {
  final Motion motion;
  final Direction direction;
  const Landscaped({this.motion, this.direction});
}