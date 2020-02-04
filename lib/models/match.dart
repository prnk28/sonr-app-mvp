import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';

class Match extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // Variables
  final String clientId;
  final MatchStatus status;
  final String firstName;
  final String lastName;
  final String profilePic;

  // *********************
  // ** Constructor Var **
  // *********************
  const Match(this.clientId, this.status, {
      this.firstName,
      this.lastName,
      this.profilePic,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
    firstName,
    lastName,
    profilePic,
    clientId
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Match fromMessage(dynamic data) {
      return Match(
        // Required Variables
          data["client_id"],
          data["status"],

          // Conditionals
          firstName: data["first_name"],
          lastName: data["last_name"],
          profilePic: data["profile_pic"]
      );
  }
}
