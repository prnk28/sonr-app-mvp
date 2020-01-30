import 'package:equatable/equatable.dart';

class Error extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;

  // *********************
  // ** Constructor Var **
  // *********************
  const Error({
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
  static Error fromJSON(dynamic json) {
// Return Object
      return Error(
          lobbyId: json["id"],
      );
  }
}
