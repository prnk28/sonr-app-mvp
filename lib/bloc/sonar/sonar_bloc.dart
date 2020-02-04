import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sonar_app/controllers/controllers.dart';
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
  StreamSubscription _sonarSubscription;

  // Constructer
  Process runningProcess;
  SonarBloc(this._motionBloc);

  // Initial State
  @override
  SonarState get initialState => Initial(runningProcess);

  // Map Events to State
  @override
  Stream<SonarState> mapEventToState(
    SonarEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Initialize) {
      yield* _mapInitializeToState(event);
    } else if (event is UpdateOrientation) {
      yield* _mapUpdateOrientationToState(event);
    } else if (event is ReadMessage) {
      yield* _mapReadMessageToState(event);
    }
    // } else if (event is Send) {
    //   yield* _mapSendToState(event);
    // } else if (event is Receive) {
    //   yield* _mapReceiveToState(event);
    // } else if (event is AutoSelect) {
    //   yield* _mapAutoSelectToState(event);
    // } else if (event is Select) {
    //   yield* _mapSelectState(event);
    // } else if (event is Request) {
    //   yield* _mapRequestToState(event);
    // } else if (event is Offered) {
    //   yield* _mapOfferedToState(event);
    // } else if (event is StartTransfer) {
    //   yield* _mapStartTransferToState(event);
    // } else if (event is CompleteTransfer) {
    //   yield* _mapCompleteTransferState(event);
    // } else if (event is CancelSonar) {
    //   yield* _mapCancelSonarToState(event);
    // } else if (event is ResetSonar) {
    //   yield* _mapResetSonarToState(event);
    // } 
  }

  // Close Subscription Streams
  @override
  Future<void> close() {
    _motionSubscription?.cancel();
    _sonarSubscription?.cancel();
    return super.close();
  }

  // On Initialize Event ->
  Stream<SonarState> _mapInitializeToState(Initialize initializeEvent) async* {
    // Initialize Variables
    Location fakeLocation = Location.fakeLocation();
    Profile fakeProfile = Profile.fakeProfile();

    // Connect to WS Join/Create Lobby
    _sonarRepository.initializeSonar(fakeLocation, fakeProfile);

    // Cancel Previous Subscriptions
    _motionSubscription?.cancel();
    _sonarSubscription?.cancel();

    // Listen to BLoC and Add InSonar Event every update
    _motionSubscription = _motionBloc.listen((state) {
      add(UpdateOrientation(newPosition: state.position));
    });

    // Subscribe to Server Messages
    _sonarSubscription = SonarRepository.sonarWS.messages.listen((json) {
      // Create Message Object
      Message newMessage = Message.incoming(json);

      // Add To Event
      add(ReadMessage(incomingMessage: newMessage));
    });
  }

  // On Shift Event ->
  Stream<SonarState> _mapUpdateOrientationToState(
      UpdateOrientation motionEvent) async* {
    // Send State
    if (motionEvent.newPosition.state == Orientation.Tilt) {
      // yield Sending();
    }
    // Receive State
    else if (motionEvent.newPosition.state == Orientation.LandscapeLeft ||
        motionEvent.newPosition.state == Orientation.LandscapeRight) {
      // yield Receiving();
    }
    // Continue Shift
    else {
      // yield Ready();
    }
  }

  // On ServerResponse Event ->
  Stream<SonarState> _mapReadMessageToState(ReadMessage messageEvent) async* {
    switch (messageEvent.incomingMessage.code) {
      // Initialized
      case 0:
        break;
      // Initialized
      case 1:
        break;
      // Initialized
      case 0:
        break;
      // Initialized
      case 0:
        break;
      // Initialized
      case 0:
        break;
      // Initialized
      case 0:
        break;
      default:
    }
  }

  //   // On Pause Event ->
  // Stream<SonarState> _mapSendToState(Send sendEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapAutoSelectToState(AutoSelect autoSelectEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapSelectState(Select selectEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapRequestToState(Request requestEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //       // On Pause Event ->
  // Stream<SonarState> _mapStartTransferToState(StartTransfer startTransferEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapCompleteTransferState(CompleteTransfer completeTransferEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapCancelSonarToState(CancelSonar cancelSonarEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

  //     // On Pause Event ->
  // Stream<SonarState> _mapResetSonarToState(ResetSonar resetSonarEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }
}
