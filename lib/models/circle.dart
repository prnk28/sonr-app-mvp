import 'package:sortedmap/sortedmap.dart';
import 'models.dart';

class Circle {
  // *******************
  // ** Initialize *****
  // *******************
  SortedMap differences;
  Map matches;
  final String status;

  Circle(this.status) {
    differences = new SortedMap(Ordering.byValue());
    matches = new Map();
  }

  // *******************
  // ** Update Circle **
  // *******************
  void update(currentDirection, data) {
    // Find Difference, Check Sender
    if (this.status == "Sender") {
      var difference = currentDirection.degrees - data["antipodal_degrees"];
      differences[data["id"]] = difference.abs();
      data["difference"] = difference.abs();
    } else {
      var difference = currentDirection.antipodalDegrees - data["degrees"];
      differences[data["id"]] = difference.abs();
      data["difference"] = difference.abs();
    }
    print("Difference: " + data["difference"].toString());

    // Add/Replace to matches object
    this.matches[data["id"]] = data;
  }

  // *************
  // ** Closest **
  // *************
  dynamic closest() {
    print(matches[differences.keys.first]);
    return matches[differences.keys.first];
  }
}
