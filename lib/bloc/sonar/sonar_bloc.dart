import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sonar_app/models/client.dart';
import 'package:sonar_app/models/location.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';

class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  final MotionBloc _motionBloc;
  SonarRepository _sonarRepository = new SonarRepository();

  // Stream Management
  StreamSubscription _motionSubscription;

  // Constructer
  SonarBloc(this._motionBloc);

  // Initial State
  @override
  SonarState get initialState => Initial();

  // Map Events to State
  @override
  Stream<SonarState> mapEventToState(
    SonarEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Initialize) {
      yield* _mapInitializeToState(event);
    } else if (event is ShiftMotion) {
      yield* _mapShiftMotionToState(event);
    } else if (event is Authenticate) {
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
    // Initialize Variables
    Location fakeLocation = Location.fakeLocation();
    Client client = Client.create();
    
    // Connect to WS Join/Create Lobby
    _sonarRepository.initializeSonar(fakeLocation, client);

    // Device Ready State
    yield Ready();

    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();

    // Listen to BLoC and Add InSonar Event every update
    _motionSubscription = _motionBloc.listen((state) {
      add(ShiftMotion(newPosition: state.position));
    });

    // _sonarSubscription = sonarWS.channel.stream.listen((message) {

    // });
  }

  // On SetZero Event ->
  Stream<SonarState> _mapShiftMotionToState(ShiftMotion motion) async* {
    // Send State
    if (motion.newPosition.state == Orientation.Tilt) {
      yield Sending();
    }
    // Receive State
    else if (motion.newPosition.state == Orientation.LandscapeLeft ||
        motion.newPosition.state == Orientation.LandscapeRight) {
      yield Receiving();
    }
    // Continue Shift
    else {
      yield Ready();
    }
  }
}
