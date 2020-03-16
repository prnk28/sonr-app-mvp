import 'package:equatable/equatable.dart';
import 'models.dart';

class Circle {
  // *******************
  // ** Class Values ***
  // *******************
  final dynamic matches;
  final Direction clientDirection;
  dynamic closestMatch;

  // *****************
  // ** Constructor **
  // *****************
  Circle(this.matches, this.clientDirection, bool sender) {
    // Temp Array of Differences
    var _differences = [];
    var _matches = {};

    // Check Sender Receiver
    if (sender) {
      // Iterate through matches
      for (final value in this.matches) {
        var matchDirection = value["direction"];
        var difference =
            clientDirection.degrees - matchDirection["antipodal_degrees"];
        difference.abs();
        value["difference"] = difference;
        _differences.add(difference);
        _matches[difference] = value;
      }
    } else {
      // Iterate through matches
      for (final value in this.matches) {
        var matchDirection = value["direction"];
        var difference =
            clientDirection.antipodalDegrees - matchDirection["degrees"];
        value["difference"] = difference.abs();
        _differences.add(difference.abs());
        _matches[difference.abs()] = value;
      }
    }

    // Find Closest Match
    _differences.sort();
    closestMatch = _matches[_differences[0]];
  }
}
