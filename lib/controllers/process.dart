import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class Process {
// *******************
  // ** JSON Values **
  // *******************
  // Variables
  Client user;
  Lobby lobby;

  // Dynamic Values
  Circle receivers;
  Circle senders;
  int receiverCount;
  int senderCount;

  // Set Values
  Client match;
  Transfer transfer;

  // Enum Values
  AuthenticationStatus matchStatus;
  AuthenticationStatus userStatus;
  SonarStage currentStage;

  // *********************
  // ** Constructor Var **
  // *********************
  Process(Client newUser){
    // Initialize Variables
    this.user = newUser;
    this.currentStage = SonarStage.CONNECTED;
  }
}
