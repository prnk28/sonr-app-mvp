import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
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
class Profile extends HiveObject {
  // *******************
  // ** Class Values ***
  // *******************
  @HiveField(0)
  String firstName;
  @HiveField(1)
  String lastName;
  @HiveField(2)
  List<int> profilePicture;

  // ***********************
  // ** Object Generation **
  // ***********************
  // Fake Data Method
  static Profile fakeProfile() {
    Profile fake = Profile();
    fake.firstName = "Name";
    fake.lastName = "Brax";
    fake.profilePicture = new List<int>();
    return fake;
  }

  // Create Object from Events
  @HiveType()
  static Profile fromMap(Map data) {
    Profile map = Profile();
    map.firstName = data["first_name"];
    map.lastName = data["last_name"];
    map.profilePicture = data["profile_pic"];
    return map;
  }

  // Create Object from Events
  static Profile fromValues(String first, String last, pic) {
    Profile values = Profile();
    values.firstName = first;
    values.lastName = last;
    values.profilePicture = pic;
    return values;
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

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final typeId = 0;

  @override
  Profile read(BinaryReader reader) {
    return Profile()..firstName = reader.read();
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer.write(obj.firstName);
  }
}
