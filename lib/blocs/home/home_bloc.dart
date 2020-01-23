import 'dart:async';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../blocs.dart';

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
     if (event is GetDirection) {
      yield DirectionZero();
      try {
        final Direction direction = await directionRepository.getDirection();
        yield DirectionSend(direction: direction);
      } catch (_) {
        yield DirectionError();
      }
    }
  }
}
