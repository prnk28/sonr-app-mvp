import 'package:equatable/equatable.dart';
import 'models.dart';
import 'package:equatable/equatable.dart';

class Circle extends Equatable {
  // *******************
  // ** Class Values ***
  // *******************
  final dynamic matches;
  final dynamic closestMatch;
  final bool sender;

  const Circle({this.matches, this.closestMatch, this.sender});

  // *****************
  // ** Constructor **
  // *****************
  static Circle fromMap(Map map, clientDirection, bool sender) {
    // Temp Array of Differences
    //var _differences = [];
    var _matches = new Map<String, double>();
    var _closestMatch;
    var matches = map.values;

    // Check Sender Receiver
    if (sender) {
      // Iterate through matches
      if (matches != null) {
        for (final value in matches) {
          var matchDirection = value["direction"];
          print("Antipodal: "+ matchDirection["antipodal_degrees"].toString());
          print("Degrees: "+ clientDirection.degrees.toString());
          var difference =
              clientDirection.degrees - matchDirection["antipodal_degrees"];
          value["difference"] = difference.abs();
          //_differences.add(difference.abs());
          _matches[value.id] = difference.abs();
        }
      }
    } else {
      // Iterate through matches
      if (matches != null) {
        for (final value in matches) {
          
          var matchDirection = value["direction"];
          print("Degrees: "+ matchDirection["degrees"].toString());
          print("Antipodal: "+ clientDirection.antipodalDegrees.toString());
          var difference =
              clientDirection.antipodalDegrees - matchDirection["degrees"];
          value["difference"] = difference.abs();
          // _differences.add(difference.abs());
          _matches[value.id] = difference.abs();
        }
      }
    }

    // Convert Differences to List
    var _differences = _matches.values.toList();

    // Sort
    _differences.sort();
    
    // Get Closest Key
    var closestKey = _matches.keys.firstWhere(
    (k) => _matches[k] == _differences[0], orElse: () => null);

    // Set Closest Match by Finding from Map
    _closestMatch = map[closestKey];
    print("Closest Match: " + _closestMatch.toString());

    return Circle(
      matches: _matches,
      closestMatch: _closestMatch,
      sender: sender
    );

  }

  // Adjust Props
  @override
  List<Object> get props => [matches, closestMatch];
}
