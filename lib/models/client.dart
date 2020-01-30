import 'package:equatable/equatable.dart';

class Client extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  final String connection;
  final DateTime joined;

  // *********************
  // ** Constructor Var **
  // *********************
  const Client(
    {
      this.id,
      this.connection,
      this.joined
      });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props =>
      [id, connection, joined];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Client fromMap(Map data) {
// Return Object
    return Client(
        id: data["id"],
        connection: data["connection"],
        joined: data["joined"]);
  }
}
