import 'dart:async';
import 'package:sonar_app/repositories/repositories.dart';
import 'package:sonar_app/bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DirectionRepository directionRepository;

  HomeBloc({@required this.directionRepository})
      : assert(directionRepository != null);

  @override
  HomeState get initialState => DirectionZero();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
