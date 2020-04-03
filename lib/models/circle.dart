import 'package:equatable/equatable.dart';
import 'models.dart';

class Circle extends Equatable {
  // *******************
  // ** Class Values ***
  // *******************
  final dynamic matches;
  final dynamic closestMatch;
  final bool sender;

  const Circle({this.matches, this.closestMatch, this.sender}){
    
  }

  // *****************
  // ** Constructor **
  // *****************
  static Circle fromMap(Map map, clientDirection, bool sender) {
    // Temp Array of Differences
    var _differences = [];
    var _matches = {};
    var _closestMatch;
    var matches;

    // Check Map Null
    if (map != null) {
      matches = map.values;
    } else {
      matches = null;
      _matches = null;
    }

    // Check Sender Receiver
    if (sender) {
      // Iterate through matches
      if (matches != null) {
        for (final value in matches) {
          var matchDirection = value["direction"];
          print("Antipodal: " + matchDirection["antipodal_degrees"].toString());
          print("Degrees: " + clientDirection.degrees.toString());
          var difference =
              clientDirection.degrees - matchDirection["antipodal_degrees"];
          value["difference"] = difference.abs();
          _differences.add(difference.abs());
          _matches[difference.abs()] = value;
        }
      }
    } else {
      // Iterate through matches
      if (matches != null) {
        for (final value in matches) {
          var matchDirection = value["direction"];
          print("Degrees: " + matchDirection["degrees"].toString());
          print("Antipodal: " + clientDirection.antipodalDegrees.toString());
          var difference =
              clientDirection.antipodalDegrees - matchDirection["degrees"];
          value["difference"] = difference.abs();
          _differences.add(difference.abs());
          _matches[difference.abs()] = value;
        }
      }
    }

    // Find Closest Match
    _differences.sort();

    // Set Match
    if(_matches != null){
      _closestMatch = _matches[_differences[0]];
    }else{
      _closestMatch = null;
    }

    return Circle(
        matches: _matches, closestMatch: _closestMatch, sender: sender);
  }

  // Adjust Props
  @override
  List<Object> get props => [matches, closestMatch];
}
