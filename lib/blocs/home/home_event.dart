import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetDirection extends HomeEvent {
  final List<double> accelerometerValues;

  const GetDirection({@required this.accelerometerValues}) : assert(accelerometerValues != null);

  @override
  List<Object> get props => [accelerometerValues];
}
