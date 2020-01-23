import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class SetDirection extends HomeEvent {
  final double direction;

  const SetDirection({@required this.direction}) : assert(direction != null);

  @override
  List<Object> get props => [direction];
}
