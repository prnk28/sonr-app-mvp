import 'package:sortedmap/sortedmap.dart';
import 'models.dart';

class Circle {
  // *******************
  // ** Initialize *****
  // *******************
  SortedMap differences;
  Map matches;
  String status;

  Circle() {
    differences = new SortedMap(Ordering.byValue());
    matches = new Map();
  }

  // ****************************************
  // ** Update Circle Due to Incoming Data **
  // ****************************************
  void update(currentDirection, data) {
    // Find Difference, Check Sender
    if (this.status == "Sender") {
      // Get Sender Difference
      var difference = currentDirection.degrees - data["antipodal_degrees"];
      this.differences[data["id"]] = difference.abs();
      data["difference"] = difference.abs();

      // Log
      print("Difference: " + data["difference"].toString());

      // Add/Replace to matches object
      this.matches[data["id"]] = data;
    } else if (this.status == "Receiver") {
      // Get Receiver Difference
      var difference = currentDirection.antipodalDegrees - data["degrees"];
      this.differences[data["id"]] = difference.abs();
      data["difference"] = difference.abs();

      // Log
      print("Difference: " + data["difference"].toString());

      // Add/Replace to matches object
      this.matches[data["id"]] = data;
    } else {
      TypeError();
    }
  }

  // ****************************************************
  // ** Remove Object from Circle Due to Incoming Data **
  // ****************************************************
  void exit(id) {
    // Remove from Differences
    this.differences.remove(id);

    // Remove from Matches
    this.matches.remove(id);
  }

  // *******************************************
  // ** Modify Circle Due to Directional Data **
  // *******************************************
  void modify(currentDirection) {
    if (this.valid()) {
      dynamic closest = this.closest();
      if (this.status == "Sender") {
        // Get Sender Difference
        var difference =
            currentDirection.degrees - closest["antipodal_degrees"];
        this.differences[closest["id"]] = difference.abs();
        closest["difference"] = difference.abs();

        // Log
        print("Difference: " + closest["difference"].toString());
      } else if (this.status == "Receiver") {
        // Get Receiver Difference
        var difference = currentDirection.antipodalDegrees - closest["degrees"];
        this.differences[closest["id"]] = difference.abs();
        closest["difference"] = difference.abs();

        // Log
        print("Difference: " + closest["difference"].toString());
      } else {
        TypeError();
      }
    }
  }

  // *******************************************
  // ** Check if Circle has Receivers/Senders **
  // *******************************************
  bool valid() {
    if (this.matches.keys.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  // *************
  // ** Closest **
  // *************
  dynamic closest() {
    if (this.valid()) {
      return this.matches[this.differences.keys.first];
    } else {
      return null;
    }
  }
}
