import 'package:equatable/equatable.dart';

class Match extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;

  // *********************
  // ** Constructor Var **
  // *********************
  const Match({
    this.lobbyId,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
    lobbyId,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Match fromJSON(dynamic json) {
// Return Object
      return Match(
          lobbyId: json["id"],
      );
  }
}
