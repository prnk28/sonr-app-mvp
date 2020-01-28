import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  final MotionBloc _motionBloc;
  SonarRepository _sonarRepository = new SonarRepository();

  // Stream Management
  StreamSubscription _motionSubscription;

  // Constructer
  SonarBloc({@required MotionBloc motionBloc})
      : assert(_motionBloc != null),
        _motionBloc = motionBloc;

  // Initial State
  @override
  SonarState get initialState => Default();

  // Map Events to State
  @override
  Stream<SonarState> mapEventToState(
    SonarEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Initialize) {
      yield* _mapInitializeToState(event);
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
    _motionSubscription?.cancel();
    return super.close();
  }

  // On Initialize Event ->
  Stream<SonarState> _mapInitializeToState(Initialize initialize) async* {
    // Connect to WS Join/Create Lobby
    _sonarRepository.initialize();
    _sonarRepository.msgJoin();

    // Device Ready State
    yield Ready();

    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();

    // Listen to BLoC and Add InSonar Event every update
    _motionSubscription = _motionBloc.listen((state) {
      if (state is Zero) {
        add(UpdatePosition(newPosition: "Zero"));
      } else if (state is Receive) {
        add(UpdatePosition(newPosition: "Receive"));
      } else if (state is Send) {
        add(UpdatePosition(newPosition: "Send"));
      }
    });

    // _sonarSubscription = sonarWS.channel.stream.listen((message) {

    // });
  }

    // On SetZero Event ->
  Stream<SonarState> _mapUpdatePositionToState(UpdatePosition position) async* {
 // Send State
    if (position.newPosition == "Send") {
      yield Sending();
    }
    // Receive State
    else if (position.newPosition == "Receive") {
      yield Receiving();
    }
    // Continue Shift
    else {
      yield Ready();
    }
  }

  //   // On SetSender Event ->
  // Stream<SonarState> _mapSetSenderToState(SetSender setSender) async* {
  //   // Add Stream for WebSockets
  //   // Device Ready State
  //   yield Sending();
  // }
}
