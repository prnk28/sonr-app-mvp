import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';

class MotionBloc extends Bloc<MotionEvent, MotionState> {
  // Data Provider
  final SensorProvider _sensorProvider;
  Motion _initialPosition = Motion.create();

  // Stream Management
  StreamSubscription<AccelerometerEvent> _motionSubscription;

  // Constructer
MotionBloc({@required SensorProvider sensorProvider})
      : assert(sensorProvider != null),
        _sensorProvider = sensorProvider;

  // Initial State
  @override
  MotionState get initialState => Zero(_initialPosition);

  // Map Events to State
  @override
  Stream<MotionState> mapEventToState(
    MotionEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Start) {
      yield* _mapStartToState(event);
    } else if (event is Pause) {
      yield* _mapPauseToState(event);
    } else if (event is Resume) {
      yield* _mapResumeToState(event);
    }
    // Device InMotion
    else if (event is InMotion) {
      yield* _mapInMotionToState(event);
    }
  }

  // Close Subscription Streams
  @override
  Future<void> close() {
    _motionSubscription?.cancel();
    return super.close();
  }

  // On Start Event ->
  Stream<MotionState> _mapStartToState(Start start) async* {
    // Device Pending State
    yield Shift(start.position);

    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();

    // Listen to Stream and Add InMotion Event every update
    _motionSubscription = _sensorProvider.motion().listen((newPosition) {
      add(InMotion(position: Motion.create(a: newPosition)));
    });
  }

  // On Pause Event ->
  Stream<MotionState> _mapPauseToState(Pause pause) async* {
    // Verify Position not Zero
    if (state is Send || state is Receive) {
      // Pause Subscription
      _motionSubscription?.pause();
      // Set Suspend state with lastState
      yield Suspend(state.position, state);
    }
  }

  // On Resume Event ->
  Stream<MotionState> _mapResumeToState(Resume pause) async* {
    // Verify Pause State
    if (state is Suspend) {
      // Referece Suspend state
      Suspend stateRef = state as Suspend;

      // lastState was Send
      if (stateRef.lastState is Send) {
        _motionSubscription?.resume();
        yield Send(state.position);
      }
      // lastState was Receive
      else if (stateRef.lastState is Receive) {
        _motionSubscription?.resume();
        yield Receive(state.position);
      }
    }
  }

  // On Reset Event ->
  Stream<MotionState> _mapResetToState(Reset reset) async* {
    // Cancel Subscription
    _motionSubscription?.cancel();
    yield Zero(_initialPosition);
  }

  // On InMotion Event ->
  Stream<MotionState> _mapInMotionToState(InMotion motion) async* {
    // Send State
    if (motion.position.state == SonarState.SEND) {
      yield Send(motion.position);
    }
    // Receive State
    else if (motion.position.state == SonarState.RECEIVE) {
      yield Receive(motion.position);
    }
    // Continue Shift
    else {
      yield Shift(motion.position);
    }
  }
}
