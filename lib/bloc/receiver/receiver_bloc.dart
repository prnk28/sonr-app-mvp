import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';


class ReceiverBloc extends Bloc<ReceiverEvent, ReceiverState> {
  StreamSubscription _sonarSubscription;
  
  @override
  ReceiverState get initialState => ReceiverReady();

  @override
  Stream<ReceiverState> mapEventToState(
    ReceiverEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
