import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/client.dart';
import 'package:sonar_app/models/models.dart';

class Process extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // Variables
  final Client user;
  final Lobby lobby;

  // Dynamic Values
  final Client match;
  final Transfer transfer;

  // Enum Values
  final AuthenticationStatus matchStatus;
  final AuthenticationStatus userStatus;
  final SonarStage currentStage;

  // *********************
  // ** Constructor Var **
  // *********************
  const Process(
    this.user,
    this.lobby, {
    this.match,
    this.transfer,
    this.matchStatus,
    this.userStatus,
    this.currentStage,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        user,
        lobby,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Default Object with Default Variables
  static Process create(Client user, Lobby lobby) {
    return Process(user, lobby,
        currentStage: SonarStage.READY,
        match: null,
        matchStatus: AuthenticationStatus.Pending,
        userStatus: AuthenticationStatus.Pending);
  }

  // ***************************************************************************
  // ** Update Object: Create New Object w/ Updated Values and Current Values **
  // ***************************************************************************
  // Update Process Object with no Values
  static Process update(Process currentProcess,
      {Match newMatchPeer,
      AuthenticationStatus newUserStatus,
      AuthenticationStatus newMatchStatus,
      SonarStage newStage}) {
    // Return Based on Provided Variables
    return Process(
        // Required Variables
        currentProcess.user,
        currentProcess.lobby,
        // Conditionals
        match:
            newMatchPeer != null ? newMatchPeer : currentProcess.match,
        userStatus:
            newUserStatus != null ? newUserStatus : currentProcess.userStatus,
        matchStatus: newMatchStatus != null
            ? newMatchStatus
            : currentProcess.matchStatus,
        currentStage:
            newStage != null ? newStage : currentProcess.currentStage);
  }

  // *************************************************
  // ** Set Authentication Status of Matched Client **
  // *************************************************
  // Update Authentication of User
  static Process setMatchAuthentication(
      Process currentProcess, bool matchAuthenticatedTransfer) {
    // Match Authenticated
    if (matchAuthenticatedTransfer) {
      // Match Accepted Authentication
      switch (currentProcess.matchStatus) {
        case AuthenticationStatus.Accepted:
          return Process.update(currentProcess,
              newStage: SonarStage.TRANSFERRING,
              newMatchStatus: AuthenticationStatus.Accepted);
          break;
        // Match Pending Authentication
        case AuthenticationStatus.Pending:
          return Process.update(currentProcess,
              newStage: SonarStage.SENDER_MATCH_PENDING,
              newMatchStatus: AuthenticationStatus.Accepted);
          break;
        // Matched User Already Declined
        case AuthenticationStatus.Declined:
          return Process.update(currentProcess,
              newStage: SonarStage.ERROR_RECEIVER_DECLINED);
      }
    }
    // If User Declined Transfer
    return Process.update(currentProcess,
        newStage: SonarStage.ERROR_SENDER_CANCELLED,
        newMatchStatus: AuthenticationStatus.Declined);
  }

  // ***********************************************
  // ** Set Authentication Status of Current User **
  // ***********************************************
  // Update Authentication of User
  static Process setUserAuthentication(
      Process currentProcess, bool authenticateTransfer) {
    // User Authenticated
    if (authenticateTransfer) {
      // Match Accepted Authentication
      switch (currentProcess.matchStatus) {
        case AuthenticationStatus.Accepted:
          return Process.update(currentProcess,
              newStage: SonarStage.TRANSFERRING,
              newUserStatus: AuthenticationStatus.Accepted);
          break;
        // Match Pending Authentication
        case AuthenticationStatus.Pending:
          return Process.update(currentProcess,
              newStage: SonarStage.SENDER_MATCH_PENDING,
              newUserStatus: AuthenticationStatus.Accepted);
          break;
        // Matched User Already Declined
        case AuthenticationStatus.Declined:
          return Process.update(currentProcess,
              newStage: SonarStage.ERROR_RECEIVER_DECLINED);
      }
    }
    // If User Declined Transfer
    return Process.update(currentProcess,
        newStage: SonarStage.ERROR_SENDER_CANCELLED,
        newUserStatus: AuthenticationStatus.Declined);
  }
}
