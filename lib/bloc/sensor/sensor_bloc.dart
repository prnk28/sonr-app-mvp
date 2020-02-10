import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  // Stream Management
  StreamSubscription<AccelerometerEvent> _motionSubscription;
  StreamSubscription<double> _directionSubscription;

  // Local Sensory Input Variables
  Direction _lastDirection = Direction.create(degrees: 0);
  Motion _currentMotion = Motion.create();

  // Constructer
  SensorBloc() {
    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();
    _directionSubscription?.cancel();

    // Listen to Stream and Add UpdateInput Event every update
    _motionSubscription = accelerometerEvents.listen((newData) {
      // Check Direction Activation
      // add(CheckActivation());

      // Update Motion Var
      _currentMotion = Motion.create(a: newData);
    });

    // Refresh Direction on Turn from Tilt
    _directionSubscription = FlutterCompass.events.listen((newData) {
      // Refresh Inputs
      add(RefreshInput(newDirection: Direction.create(degrees: newData)));
    });
  }

  // Initial State
  @override
  SensorState get initialState => Default();

  @override
  Stream<SensorState> mapEventToState(
    SensorEvent event,
  ) async* {
    // Device Can See Updates
    if (event is CheckActivation) {
      yield* _mapCheckActivationToState(event);
    } else if (event is RefreshInput) {
      yield* _mapRefreshInputToState(event);
    } else if (event is CompareDirections) {
      yield* _mapCompareDirectionsToState(event);
    }
  }

  // Close Subscription Streams
  @override
  Future<void> close() {
    _motionSubscription?.cancel();
    _directionSubscription?.cancel();
    return super.close();
  }

  // On Pause Event ->
  Stream<SensorState> _mapCheckActivationToState(
      CheckActivation activation) async* {
    // Verify Motion Orientation
    if (state is Default) {
      // Resume Direction Subscription
      _directionSubscription?.pause();
    } else {
      // Pause Direction Subscription
      _directionSubscription?.resume();
    }
  }

  // On InMotion Event ->
  Stream<SensorState> _mapRefreshInputToState(
      RefreshInput updateSensors) async* {
    // Check State
    if (_currentMotion.state == Orientation.Tilt ||
        _currentMotion.state == Orientation.LandscapeLeft ||
        _currentMotion.state == Orientation.LandscapeRight) {
      // Compare Directions
      add(CompareDirections(_lastDirection, updateSensors.newDirection));
      // Pending State
      yield Loading();
    }
    // Continue Shift
    else {
      yield Default(motion: _currentMotion);
    }
  }

  // On InMotion Event ->
  Stream<SensorState> _mapCompareDirectionsToState(
      CompareDirections compareDirections) async* {
    // Check Directions
    if (compareDirections.lastDirection != compareDirections.newDirection) {
      // Set as new direction
      _lastDirection = compareDirections.newDirection;
    }

    // Check State
    if (_currentMotion.state == Orientation.Tilt) {
      // Update State
      yield Tilted(motion: _currentMotion, direction: _lastDirection);
    }
    // Receive State
    else if (_currentMotion.state == Orientation.LandscapeLeft ||
        _currentMotion.state == Orientation.LandscapeRight) {
      // Update State
      yield Landscaped(motion: _currentMotion, direction: _lastDirection);
    }
    // Continue Shift
    else {
      yield Default(motion: _currentMotion);
    }
  }
}
