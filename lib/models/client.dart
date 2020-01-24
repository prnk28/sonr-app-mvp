import 'package:equatable/equatable.dart';

class Client extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String firstName;
  final String lastName;
  final String profilePic;
  final String id;
  final String connection;
  final Client peer;
  final List<Client> peerCircle;

  // *********************
  // ** Constructor Var **
  // *********************
  const Client(
      {this.firstName,
      this.lastName,
      this.profilePic,
      this.id,
      this.connection,
      this.peer,
      this.peerCircle});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props =>
      [firstName, lastName, profilePic, id, connection, peer, peerCircle];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Client fromJSON(dynamic json) {
// Return Object
    return Client(
        firstName: json["FIRST_NAME"],
        lastName: json["LAST_NAME"],
        profilePic: json["PROFILE_PIC"],
        id: json["receivers_map"],
        connection: json["total_lobby_clients"]);
  }
}
