import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

// Device Connected to WS
class Client extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  final DateTime joined;
  final Profile user;

  // *****************
  // ** Constructor **
  // *****************
  const Client({this.id, this.joined, this.user});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [id, joined, user];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Client fromMap(Map data) {
    return Client(id: data["id"], joined: data["joined"]);
  }

  // Create Default Object
  static Client create() {
    return Client(
        id: null,
        joined: DateTime.now(),
        // TODO: Fix Profile Temporary Fix
        user: Profile.fakeProfile());
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  toMap() {
    return {'id': id, 'joined': joined.toString(), 'profile': user.toMap()};
  }
}

// Match Version of Client
class Match extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  final Direction direction;
  final Profile user;

  // *****************
  // ** Constructor **
  // *****************
  const Match({this.id, this.direction, this.user});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [id, direction, user];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Match fromJson(Map data) {
    return Match(
        id: data["id"],
        direction: Direction.fromMap(data["direction"]),
        user: Profile.fromMap(data["profile"]));
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  toMap() {
    return {
      'id': id,
      'direction': direction.toSendMap(),
      'profile': user.toMap()
    };
  }
}

// Basic Profile Class for Client
class Profile {
  // *******************
  // ** Class Values ***
  // *******************
  final String firstName;
  final String lastName;
  final String profilePicture;

  // *****************
  // ** Constructor **
  // *****************
  Profile(this.firstName, this.lastName, this.profilePicture);

  // ***********************
  // ** Object Generation **
  // ***********************
  // Fake Data Method
  static Profile fakeProfile() {
    return Profile("Napoleon", "Braxton",
        "https://ui-avatars.com/api/?name=Napoleon+Braxton");
  }

  // Create Object from Events
  static Profile fromMap(Map data) {
    return Profile(data["first_name"], data["last_name"], data["profile_pic"]);
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture
    };
  }
}
