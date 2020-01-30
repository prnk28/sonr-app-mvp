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
    // Connect to WS Join/Create Lobby
    _sonarRepository.initialize();
    _sonarRepository.msgJoin();

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
    if (motion.newPosition.state == Orientation.SEND) {
      yield Sending();
    }
    // Receive State
    else if (motion.newPosition.state == Orientation.RECEIVE) {
      yield Receiving();
    }
    // Continue Shift
    else {
      yield Ready();
    }
  }
}
