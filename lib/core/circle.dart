import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sortedmap/sortedmap.dart';

class Circle {
  // *******************
  // ** Initialize *****
  // *******************
  SortedMap differences;
  Map matches;
  WebBloc bloc;

  Circle(this.bloc) {
    differences = new SortedMap(Ordering.byValue());
    matches = new Map();
  }

  // ****************************************
  // ** Update Circle Due to Incoming Data **
  // ****************************************
  void update(currentDirection, data) {
    switch (bloc.device.status) {
      // Find Difference, Check Sender
      case PositionStatus.RECEIVER:
        // Get Receiver Difference
        var difference = currentDirection.antipodalDegrees - data["degrees"];
        this.differences[data["id"]] = difference.abs();
        data["difference"] = difference.abs();

        // Add/Replace to matches object
        this.matches[data["id"]] = data;
        break;
      case PositionStatus.SENDER:
        // Get Sender Difference
        var difference = currentDirection.degrees - data["antipodal_degrees"];
        this.differences[data["id"]] = difference.abs();
        data["difference"] = difference.abs();

        // Add/Replace to matches object
        this.matches[data["id"]] = data;
        break;
      default:
        log.e("Not Receiver nor Sender");
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

  // ******************
  // ** Reset Circle **
  // ******************
  void reset() {
    // Clear Maps
    this.differences.clear();
    this.matches.clear();
  }

  // *******************************************
  // ** Modify Circle Due to Directional Data **
  // *******************************************
  void modify(currentDirection) {
    if (this.valid()) {
      dynamic closest = this.closestProfile();
      switch (bloc.device.status) {
        case PositionStatus.RECEIVER:
          // Get Receiver Difference
          var difference =
              currentDirection.antipodalDegrees - closest["degrees"];
          this.differences[closest["id"]] = difference.abs();
          closest["difference"] = difference.abs();
          break;
        case PositionStatus.SENDER:
          // Get Sender Difference
          var difference =
              currentDirection.degrees - closest["antipodal_degrees"];
          this.differences[closest["id"]] = difference.abs();
          closest["difference"] = difference.abs();

          // Log
          print("Difference: " + closest["difference"].toString());
          break;
        default:
          log.e("Not Receiver nor Sender");
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

  // ***************************************
  // ** Check if Closest Within Threshold **
  // ***************************************
  bool withinThreshold() {
    if (this.valid()) {
      if (this.closestProfile()["difference"] <= 30) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // **************************
  // ** Closest Peer Methods **
  // **************************
  String closestId() {
    return this.closestProfile()["id"];
  }

  dynamic closestProfile() {
    if (this.valid()) {
      return this.matches[this.differences.keys.first];
    } else {
      log.e("There is no closest Peer");
      return null;
    }
  }
}
