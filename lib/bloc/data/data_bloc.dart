import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(null);

  // Initialize Repositories
  LocalData localData = new LocalData();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
