import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

abstract class SonarEvent extends Equatable {
  const SonarEvent();

  @override
  List<Object> get props => [];
}

// *********************
// ** Single Events ****
// *********************
// Connect to WS, Join/Create Lobby
class Initialize extends SonarEvent {
  final Profile userProfile;
  const Initialize({this.userProfile});
}

// Send to Server Sequence
class Select extends SonarEvent {
  final File file;

  const Select({this.file});
}

// Send to Server Sequence
class Send extends SonarEvent {
  final Circle map;

  const Send({this.map});
}

// Receive to Server Sequence
class Receive extends SonarEvent {
  final Circle map;

  const Receive({this.map});
}

// Sender Invites Authorization
class Invite extends SonarEvent {
  final String id;
  const Invite(this.id);
}

// Receiver Gets Authorization Request
class Offered extends SonarEvent {
  final dynamic offer;
  final dynamic profile;
  const Offered({this.offer, this.profile});
}

// Receiver Gets Authorization Request
class Authorize extends SonarEvent {
  final bool decision;
  final String matchId;
  final dynamic offer;
  const Authorize(this.decision, this.matchId, this.offer);
}

// Receiver has Accepted
class Accepted extends SonarEvent {
  final dynamic profile;
  final dynamic answer;
  final String matchId;
  const Accepted(this.profile, this.matchId, this.answer);
}

// Receiver has Declined
class Declined extends SonarEvent {
  final String matchId;
  final dynamic profile;
  const Declined(this.profile, this.matchId);
}

// Sender Begins Transfer
class Transfer extends SonarEvent {
  const Transfer();
}

// Update Progress
class ProgressCubit extends Cubit<double> {
  ProgressCubit() : super(0);

  void increment(double increase) {
    // Modify State Double
    emit(state + increase);

    // Log Progress
    //log.i("Send Progress: " + (state * 100).toString() + "%");
  }
}

// Sender Sent Transfer
class Received extends SonarEvent {
  final File data;
  const Received(this.data);
}

// On Transfer Complete
class Completed extends SonarEvent {
  final String matchId;
  final dynamic profile;
  const Completed(this.profile, this.matchId);
}

// Reset UI
class Reset extends SonarEvent {
  final int secondDelay;
  const Reset(this.secondDelay);
}

// Update Sensory Input
class Refresh extends SonarEvent {
  final Direction newDirection;

  Refresh({this.newDirection});
}

// Update Event
class Update extends SonarEvent {
  final Circle map;
  final Motion currentMotion;
  final Direction currentDirection;

  const Update({this.map, this.currentDirection, this.currentMotion});
}
