import 'package:sonar_frontend/utils/location_util.dart';

class ProfileModel {
  // Paramaters
  final LocationData location;

  // Constructor
  ProfileModel(this.location);

  // TODO: sonar_id "Add MongoDB reference ID to be able to modify/reference user details"
  // Generation Method
  toJSONEncodable() {
    return {
      'first_name' : location.toJSONEncodable(),
      'last_name' : location.latitude,
      'profile_picture' : location.longitude,
    };
  }
}