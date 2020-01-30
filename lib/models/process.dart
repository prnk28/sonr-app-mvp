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
  final Lobby currentLobby;

  // Dynamic Values
  final Match matchedClient;

  // Enum Values
  final AuthenticationStatus matchStatus;
  final AuthenticationStatus userStatus;
  final FailType error;
  final SonarStage currentStage;

  // *********************
  // ** Constructor Var **
  // *********************
  const Process(
    this.user,
    this.currentLobby, {
    this.matchedClient,
    this.matchStatus,
    this.userStatus,
    this.error,
    this.currentStage,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        user,
        currentLobby,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Default Object with Default Variables
  static Process create(Client user, Lobby lobby) {
    return Process(user, lobby,
        currentStage: SonarStage.Ready,
        error: FailType.None,
        matchedClient: null,
        matchStatus: AuthenticationStatus.Default,
        userStatus: AuthenticationStatus.Default);
  }

  // ***************************************************************************
  // ** Update Object: Create New Object w/ Updated Values and Current Values **
  // ***************************************************************************
  // Update Process Object with no Values
  static Process update(Process currentProcess,
      {Match newMatchPeer,
      AuthenticationStatus newUserStatus,
      AuthenticationStatus newMatchStatus,
      FailType newError,
      SonarStage newStage}) {
    // Return Based on Provided Variables
    return Process(
        // Required Variables
        currentProcess.user,
        currentProcess.currentLobby,
        // Conditionals
        matchedClient:
            newMatchPeer != null ? newMatchPeer : currentProcess.matchedClient,
        userStatus:
            newUserStatus != null ? newUserStatus : currentProcess.userStatus,
        matchStatus: newMatchStatus != null
            ? newMatchStatus
            : currentProcess.matchStatus,
        error: newError != null ? newError : currentProcess.error,
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
              newStage: SonarStage.Transferring,
              newError: FailType.None,
              newMatchStatus: AuthenticationStatus.Accepted);
          break;
        // Match Pending Authentication
        case AuthenticationStatus.Default:
          return Process.update(currentProcess,
              newStage: SonarStage.Pending,
              newError: FailType.None,
              newMatchStatus: AuthenticationStatus.Accepted);
          break;
        // Matched User Already Declined
        case AuthenticationStatus.Declined:
          return Process.update(currentProcess,
              newStage: SonarStage.Error, newError: FailType.MatchDeclined);
      }
    }
    // If User Declined Transfer
    return Process.update(currentProcess,
        newStage: SonarStage.Error,
        newError: FailType.MatchDeclined,
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
              newStage: SonarStage.Transferring,
              newError: FailType.None,
              newUserStatus: AuthenticationStatus.Accepted);
          break;
        // Match Pending Authentication
        case AuthenticationStatus.Default:
          return Process.update(currentProcess,
              newStage: SonarStage.Pending,
              newError: FailType.None,
              newUserStatus: AuthenticationStatus.Accepted);
          break;
        // Matched User Already Declined
        case AuthenticationStatus.Declined:
          return Process.update(currentProcess,
              newStage: SonarStage.Error, newError: FailType.MatchDeclined);
      }
    }
    // If User Declined Transfer
    return Process.update(currentProcess,
        newStage: SonarStage.Error,
        newError: FailType.UserCancelled,
        newUserStatus: AuthenticationStatus.Declined);
  }
}
