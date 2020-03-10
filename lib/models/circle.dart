import 'package:equatable/equatable.dart';
import 'models.dart';

class Circle {
  // *******************
  // ** Class Values ***
  // *******************
  final List<Match> circle;

  // *****************
  // ** Constructor **
  // *****************
  const Circle({
    this.circle,
  });

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Circle fromMap(List data) {
    // Initialize
    List<Match> temp = new List<Match>();
    
    // Iterate through JSON Map
    for (var peer in data) {
      // Convert Map to Object
      temp.add(Match.fromJson(peer));
    }

    print("CIRCLE SIZE: " + temp.length.toString());
    return Circle(circle: temp);
  }
}
