import 'package:equatable/equatable.dart';
import 'models.dart';

class Circle {
  // *******************
  // ** Class Values ***
  // *******************
  final String lobbyId;
  final int size;
  final List<Match> circle;

  // *****************
  // ** Constructor **
  // *****************
  const Circle({
    this.lobbyId,
    this.size,
    this.circle,
  });

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Circle fromMap(Map data) {
    // Initialize
    List circleData = data["circle"];
    List<Match> temp = new List<Match>();
    
    // Iterate through JSON Map
    for (var peer in circleData) {
      // Convert Map to Object
      temp.add(Match.fromMap(peer));
    }

    return Circle(lobbyId: data["lobbyId"], size: data["size"], circle: temp);
  }
}
