import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/location_util.dart';
import 'package:sonar_frontend/utils/time_util.dart';
import 'package:uuid/uuid.dart';

class MatchRequest {
  // Paramaters
  final LocationData location;
  final ProfileModel userData;
  final TimeData time;
  var id;

  // Initialization
  MatchRequest(this.userData, this.location, this.time){
    var _uuid = new Uuid();
    id = _uuid.v4();
  }

  // Generation Method
  toJSONEncodable() {
    // Create Map
    var map = {
      'id': id,
      'created': time.toJSONEncodable(),
      'metadata' : location.toJSONEncodable(),
      'latitude' : location.latitude,
      'longitude' : location.longitude,
      'userData' : userData.toJSONEncodable(),
      'message' : _generateMessage()
    };

    return map;
  }

  // Create Message
  _generateMessage(){
    // Get Data
    //Message Outline
    return " and you met on the " + time.dayPart + " of "
     + time.yearPart + " at " + location.neighborhood + ".";
  }
}