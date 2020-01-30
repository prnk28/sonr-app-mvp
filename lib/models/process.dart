import 'package:equatable/equatable.dart';

class Process extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;

  // *********************
  // ** Constructor Var **
  // *********************
  const Process({
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
  static Process fromJSON(dynamic json) {
// Return Object
      return Process(
          lobbyId: json["id"],

  }
}
