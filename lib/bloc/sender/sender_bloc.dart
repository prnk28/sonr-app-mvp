import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';


class SenderBloc extends Bloc<SenderEvent, SenderState> {
  StreamSubscription _sonarSubscription;

  @override
  SenderState get initialState => SenderReady();

  @override
  Stream<SenderState> mapEventToState(
    SenderEvent event,
  ) async* {
    // Device Can See Updates
    if (event is SenderStart) {
      yield* _mapSenderStartToState(event);
    } else if (event is UpdatePosition) {
      yield* _mapUpdatePositionToState(event);
    } else if (event is SetAuthentication) {
      //yield* _mapSetSenderToState(event);
    }
    // Device InMotion
    else if (event is Cancel) {
      // yield* _mapCancelToState(event);
    } else if (event is Done) {
      // yield* _mapDoneToState(event);
    }
  }

  // Close Subscription Streams
  @override
  Future<void> close() {
    _sonarSubscription?.cancel();
    return super.close();
  }

  // On Initialize Event ->
  Stream<SenderState> _mapSenderStartToState(SenderStart senderStart) async* {
    // Connect to WS Join/Create Lobby

    // Device Ready State
    yield SenderReady();

    // Cancel Previous Subscriptions
    _sonarSubscription?.cancel();

    // Listen to BLoC and Add InSonar Event every update
    _sonarSubscription = sonarWS.channel.stream.listen((message) {

    });

  }
}

