import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/direction.dart';
import 'package:sonar_app/models/motion.dart';


abstract class SensorEvent extends Equatable {
  const SensorEvent();

    @override
  List<Object> get props => [];
}

class CheckActivation extends SensorEvent{}

class CompareDirections extends SensorEvent{
  final Direction lastDirection;
  final Direction newDirection;

  CompareDirections(this.lastDirection, this.newDirection);
}

class RefreshInput extends SensorEvent{
  final Direction newDirection;

  RefreshInput({this.newDirection});
}