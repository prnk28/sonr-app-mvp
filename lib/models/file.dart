import 'package:equatable/equatable.dart';

class File extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;

  // *********************
  // ** Constructor Var **
  // *********************
  const File({
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
  static File fromJSON(dynamic json) {
// Return Object
      return File(
          lobbyId: json["id"],
      );
  }
}
