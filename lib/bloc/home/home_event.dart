import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetDirection extends HomeEvent {
  final double degrees;

  const GetDirection({@required this.degrees}) : assert(degrees != null);

  @override
  List<Object> get props => [degrees];
}
