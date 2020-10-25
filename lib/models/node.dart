import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// ** Status of Node **
enum Status {
  Offline, // Offline Status
  Available, // Ready to Receive
  Searching, // Looking for Peers
  Busy, // Pending/Waiting/Transferring
}

class Node {
  // Management
  String id;
  String olc;
  String device;
  Profile profile;
  Status status;
  DateTime lastUpdated;

  // Sensory Variables
  double direction;
  double distance;
  Proximity proximity;

  // ************
  // ** Object **
  // *************
  Node(this.profile) {
    // Set Default Variables
    this.status = Status.Offline;
    this.device = Platform.operatingSystem.toUpperCase();
    this.direction = 0.01;
  }

  // Build Peer from Map
  static Node fromMap(Map map) {
    Node neighbor = new Node(Profile.fromMap(map['profile']));
    neighbor.id = map['id'];
    neighbor.device = map["device"];
    neighbor.direction = map['direction'];
    neighbor.status = enumFromString(map["status"], Status.values);
    return neighbor;
  }

  //  Convert Object to Map
  toMap() {
    return {
      'id': this.id,
      'device': this.device,
      'direction': this.direction.toDouble(),
      'profile': this.profile.toMap(),
      'status': enumAsString(this.status)
    };
  }

  // ************
  // ** Device **
  // ************
  // Set Node Current Location as OLC
  setLocation() async {
    // Get Location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Encode OLC
    this.olc = OLC.encode(position.latitude, position.longitude, codeLength: 8);
  }
}
