import 'package:hive/hive.dart';

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
  String profilePicture;

  // ***********************
  // ** Object Generation **
  // ***********************
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
  final typeId = 3;

  @override
  Profile read(BinaryReader reader) {
    return Profile()..firstName = reader.read(0);
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer.write(obj.firstName);
  }
}
