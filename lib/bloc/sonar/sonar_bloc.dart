import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';

// *********************
// ** Initialization ***
// *********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  final OrientationBloc _motionBloc;
  SonarRepository _sonarRepository = new SonarRepository();

  // Stream Management
  StreamSubscription _motionSubscription;

  // Constructer
  SonarBloc(this._motionBloc) {
    // Subscribe to Server WS Updates
    sonarWS.addListener(_onMessageReceived);

    // Subscribe to Motion BLoC Updates
    _motionSubscription = _motionBloc.listen((state) {
      add(UpdateOrientation(newPosition: state.position));
    });
  }

  // Initial State
  @override
  SonarState get initialState => Initial();

  // Subscribe to Sonar Websockets Messages
  _onMessageReceived(Message message) {
    add(ReadMessage(incomingMessage: message));
  }

// *********************************
// ** Map Events to State Method ***
// *********************************
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

// ***************************
// ** Close Streams on End ***
// ***************************
  @override
  Future<void> close() {
    _motionSubscription?.cancel();
    sonarWS.removeListener(_onMessageReceived);
    return super.close();
  }

// ***********************
// ** Initialize Event ***
// ***********************
  Stream<SonarState> _mapInitializeToState(Initialize initializeEvent) async* {
    // Initialize Variables
    Location fakeLocation = Location.fakeLocation();
    Profile fakeProfile = Profile.fakeProfile();

    // Connect to WS Join/Create Lobby
    _sonarRepository.initializeSonar(fakeLocation, fakeProfile);

    // Device Pending State
    yield Ready(initializeEvent.runningProcess);
  }

// ***********************************
// ** On Device Orientation Update ***
// ***********************************
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

// ************************
// ** ReadMessage Event ***
// ************************
  Stream<SonarState> _mapReadMessageToState(ReadMessage messageEvent) async* {
    print("MapReadMessage: " + messageEvent.incomingMessage.toString());
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

// *****************
// ** Send Event ***
// *****************
  // Stream<SonarState> _mapSendToState(Send sendEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ********************
// ** Receive Event ***
// ********************
  // Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ************************
// ** Auto-Select Event ***
// ************************
  // Stream<SonarState> _mapAutoSelectToState(AutoSelect autoSelectEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// *******************
// ** Select Event ***
// *******************
  // Stream<SonarState> _mapSelectState(Select selectEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ********************
// ** Request Event ***
// ********************
  // Stream<SonarState> _mapRequestToState(Request requestEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ********************************
// ** Receiver Gets Offer Event ***
// ********************************
  // Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ***************************
// ** Begin Transfer Event ***
// ***************************
  // Stream<SonarState> _mapStartTransferToState(StartTransfer startTransferEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ******************************
// ** Complete Transfer Event ***
// ******************************
  // Stream<SonarState> _mapCompleteTransferState(CompleteTransfer completeTransferEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ****************************
// ** Cancel Transfer Event ***
// ****************************
  // Stream<SonarState> _mapCancelSonarToState(CancelSonar cancelSonarEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }

// ************************
// ** Reset Sonar Event ***
// ************************
  // Stream<SonarState> _mapResetSonarToState(ResetSonar resetSonarEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Sending();
  // }
}
