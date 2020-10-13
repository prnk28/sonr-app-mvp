import 'package:hive/hive.dart';
import 'package:sonar_app/core/core.dart';

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

  Profile(this.firstName, this.lastName, this.profilePicture);

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  @HiveType()
  static Profile fromMap(Map data) {
    return Profile(data["first_name"], data["last_name"], data["profile_pic"]);
  }

  // Create Object from Events
  static Profile fromValues(String first, String last, pic) {
    return Profile(first, last, pic);
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
  final typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.profilePicture);
  }
}
