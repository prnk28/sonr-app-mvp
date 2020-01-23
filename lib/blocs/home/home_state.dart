import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';
import 'package:meta/meta.dart';
export 'package:bloc/bloc.dart';
export 'package:meta/meta.dart';
export 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class DirectionZero extends HomeState {}

class DirectionReceive extends HomeState {
  final Direction direction;

  const DirectionReceive({@required this.direction}) : assert(direction != null);

  @override
  List<Object> get props => [direction];
}

class DirectionSend extends HomeState {
  final Direction direction;

  const DirectionSend({@required this.direction}) : assert(direction != null);

  @override
  List<Object> get props => [direction];
}

class DirectionError extends HomeState {}