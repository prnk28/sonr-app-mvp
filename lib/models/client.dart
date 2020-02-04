import 'package:equatable/equatable.dart';

class Client extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  final DateTime joined;

  // *********************
  // ** Constructor Var **
  // *********************
  const Client(
    {
      this.id,
      this.joined,
      });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props =>
      [id, joined];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Client fromMap(Map data) {
// Return Object
    return Client(
        id: data["id"],
        joined: data["joined"]);
  }
}
