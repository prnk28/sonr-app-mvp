import 'package:equatable/equatable.dart';
import 'package:sonar_app/model/direction_model.dart';
import 'package:meta/meta.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class DirectionZero extends HomeState {}

class DirectionReceive extends HomeState {
  final DirectionModel directionModel;

  const DirectionReceive({@required this.directionModel}) : assert(directionModel != null);

  @override
  List<Object> get props => [directionModel];
}

class DirectionSend extends HomeState {
  final DirectionModel directionModel;

  const DirectionSend({@required this.directionModel}) : assert(directionModel != null);

  @override
  List<Object> get props => [directionModel];
}

class DirectionError extends HomeState {}