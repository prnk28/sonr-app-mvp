import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';
import 'package:meta/meta.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  final MotionBloc _motionBloc;

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
    } else if (event is SetZero) {
      yield* _mapSetZeroToState(event);
    } else if (event is SetSender) {
      yield* _mapSetSenderToState(event);
    } else if (event is SetReceiver) {
      // yield* _mapSetReceiverToState(event);
    } else if (event is Approve) {
      // yield* _mapApproveToState(event);
    } else if (event is Decline) {
      // yield* _mapDeclineToState(event);
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

    // Device Ready State
    yield Ready();

    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();

    // Listen to BLoC and Add InSonar Event every update
    _motionSubscription = _motionBloc.listen((state) {
      if (state is Zero) {
        add(SetZero());
      } else if (state is Receive) {
        add(SetReceiver());
      } else if (state is Send) {
        add(SetSender());
      }
    });
  }

    // On SetZero Event ->
  Stream<SonarState> _mapSetZeroToState(SetZero setZero) async* {
    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();

    // Device Ready State
    yield Ready();
  }

    // On SetSender Event ->
  Stream<SonarState> _mapSetSenderToState(SetSender setSender) async* {
    // Add Stream for WebSockets
    // Device Ready State
    yield Sending();
  }
}
