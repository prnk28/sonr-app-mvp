import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/controllers/controllers.dart';

// *********************
// ** Initialization ***
// *********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  final SensorBloc _sensorBloc;
  SonarRepository _sonarRepository = new SonarRepository();

  // Variables
  Process _currentProcess;

  // Stream Management
  StreamSubscription _sensorSubscription;

  // Constructer
  SonarBloc(this._sensorBloc) {
    // Subscribe to Server WS Updates
    sonarWS.addListener(_onMessageReceived);

    // Subscribe to Motion BLoC Updates
    _sensorSubscription = _sensorBloc.listen((state) {
      if (state is Tilted) {
        add(UpdateSensors(direction: state.direction, motion: state.motion));
      } else if (state is Landscaped) {
        add(UpdateSensors(direction: state.direction, motion: state.motion));
      }
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
    } else if (event is UpdateSensors) {
      yield* _mapUpdateOrientationToState(event);
    } else if (event is ReadMessage) {
      yield* _mapReadMessageToState(event);
    }
    // } else if (event is Send) {
    //   yield* _mapSendToState(event);
    // } else if (event is Receive) {
    //   yield* _mapReceiveToState(event);
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
    _sensorSubscription?.cancel();
    sonarWS.removeListener(_onMessageReceived);
    sonarWS.disconnect();
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
    yield Ready();
  }

// ***********************************
// ** On Device Orientation Update ***
// ***********************************
  Stream<SonarState> _mapUpdateOrientationToState(
      UpdateSensors sensorInput) async* {
    // Send State
    if (sensorInput.motion.state == Orientation.Tilt) {
      yield Sending(sensorInput.direction);
    }
    // Receive State
    else if (sensorInput.motion.state == Orientation.LandscapeLeft ||
        sensorInput.motion.state == Orientation.LandscapeRight) {
      yield Receiving(sensorInput.direction);
    }
    // Continue Shift
    else {
      yield Ready();
    }
  }

// ************************
// ** ReadMessage Event ***
// ************************
  Stream<SonarState> _mapReadMessageToState(ReadMessage messageEvent) async* {
    print("MapReadMessage: " + messageEvent.incomingMessage.toString());
    switch (messageEvent.incomingMessage.code) {
      // Connected
      case 0:
        // Create Client and Initialize Process
        _currentProcess = new Process(Client.fromMap(messageEvent.incomingMessage.data));
        break;
      // Ready
      case 1:
        // Add to Process
        _currentProcess.lobby = Lobby.fromMap(messageEvent.incomingMessage.data);

        // Update Status
        _currentProcess.currentStage = SonarStage.READY;
        break;
      // Sending
      case 10:
        // Update Receivers Circle
        _currentProcess.receivers = Circle.fromMap(messageEvent.incomingMessage.data["receivers"]);
        
        // Update Status
        _currentProcess.currentStage = SonarStage.SENDING;
        break;
      // Sender Match Found
      case 11:
        break;
      // Sender Match Requested
      case 12:
        break;
      // Receiving
      case 20:
        // Update Senders Circle
        _currentProcess.senders = Circle.fromMap(messageEvent.incomingMessage.data["senders"]);
        
        // Update Status
        _currentProcess.currentStage = SonarStage.RECEIVING;
        break;
      // Receiver Offered
      case 21:
        break;
      // Receiver Authorized
      case 22:
        break;
      // Transferring
      case 30:
        break;
      // Transfer Recepient
      case 31:
        break;
      // Transfer Complete
      case 32:
        break;
      // Error: Receiver Declined
      case 40:
        break;
      // Error: Sender Cancelled
      case 41:
        break;
      // Error: Sender Timeout
      case 42:
        break;
      // Error: Transfer Fail
      case 43:
        break;
      // Error: WS Down
      case 44:
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

// ********************
// ** Compare Event ***
// ********************
  // Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
  //     // Set Suspend state with lastState
  //     yield Pending();
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
