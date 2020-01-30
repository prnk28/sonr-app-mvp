import 'package:equatable/equatable.dart';

class Data extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;

  // *********************
  // ** Constructor Var **
  // *********************
  const Data({
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
  static Data fromJSON(dynamic json) {
// Return Object
      return Data(
          lobbyId: json["id"],
      );
  }
}
