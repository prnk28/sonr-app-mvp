import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors/sensors.dart';
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
  SonarRepository _sonarRepository = new SonarRepository();
  final SensorBloc _sensorBloc;
  StreamSubscription _sensorSubscription;
  StreamSubscription<AccelerometerEvent> _motionSubscription;
  Direction _lastDirection;
  Motion _currentMotion = Motion.create();

  // Variables
  Process _currentProcess;

  // Constructer
  SonarBloc(this._sensorBloc) {
    // Subscribe to Server WS Updates
    sonarWS.addListener(_onMessageReceived);

     // Listen to Stream and Add UpdateInput Event every update
    _motionSubscription = accelerometerEvents.listen((newData) {
      // Update Motion Var
      _currentMotion = Motion.create(a: newData);
    });

      // Subscribe to Motion BLoC Updates
    _sensorSubscription = FlutterCompass.events.listen((newData) {
      // Refresh Inputs
      _lastDirection = Direction.create(degrees: newData, accelerometerX: _currentMotion.accelX);
    });
  }

  // Initial State
  @override
  SonarState get initialState => Initial();

// *********************
// ** Read Server Msg **
// *********************
  // Subscribe to Sonar Websockets Messages
  _onMessageReceived(Message message) {
    print(message.data);
    switch (message.code) {
      // Connected
      case 0:
        // Create Client and Initialize Process
        _currentProcess = new Process(Client.fromMap(message.data));
        break;
      // Ready
      case 1:
        // Add to Process
        _currentProcess.lobby = Lobby.fromMap(message.data);

        // Update Status
        _currentProcess.currentStage = SonarStage.READY;
        break;
      // Sending
      case 10:
        // Update Status
        _currentProcess.currentStage = SonarStage.SENDING;
        add(Update(map: Circle.fromMap(message.data["receivers"], _lastDirection, true)));
        break;
      // Sender Match Found
      case 11:
        break;
      // Sender Match Requested
      case 12:
        break;
      // Receiving
      case 20:
        // Update Status
        _currentProcess.currentStage = SonarStage.RECEIVING;
        add(Update(map: Circle.fromMap(message.data["senders"], _lastDirection, false)));
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
    } else if (event is Send) {
      yield* _mapSendToState(event);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event);
    }
    else if (event is Update) {
      yield* _mapUpdateToState(event);
    }
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

// *****************
// ** Send Event ***
// *****************
  Stream<SonarState> _mapSendToState(Send sendEvent) async* {
    // Set Suspend state with lastState
    yield Sending(matches: sendEvent.map);
  }

// ********************
// ** Receive Event ***
// ********************
  Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
    // Set Suspend state with lastState
    yield Receiving(matches: receiveEvent.map);
  }

// ********************
// ** Update Event ***
// ********************
  Stream<SonarState> _mapUpdateToState(Update updateEvent) async* {
      if(updateEvent.map.sender){
        add(Send(map: updateEvent.map));
      }else{
        add(Receive(map: updateEvent.map));
      }
      // Set Suspend state with lastState
      yield Updating();
  }

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
