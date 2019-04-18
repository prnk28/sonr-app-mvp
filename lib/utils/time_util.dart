import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtility {
  // Generate Part of Day
  static partOfDay(DateTime n) {
    TimeOfDay now = TimeOfDay.fromDateTime(n);
    if (now.hour >= 2 && now.hour < 5) {
      return "Late Night";
    } else if (now.hour >= 5 && now.hour < 8) {
      return "Early Morning";
    } else if (now.hour >= 8 && now.hour < 11) {
      return "Morning";
    } else if (now.hour >= 11 && now.hour < 12) {
      return "Late Morning";
    } else if (now.hour >= 12 && now.hour < 14) {
      return "Early Afternoon";
    } else if (now.hour >= 14 && now.hour < 16) {
      return "Afternoon";
    } else if (now.hour >= 16 && now.hour < 17) {
      return "Late Afternoon";
    } else if (now.hour >= 17 && now.hour < 19) {
      return "Early Evening";
    } else if (now.hour >= 19 && now.hour < 21) {
      return "Evening";
    } else if (now.hour >= 21 && now.hour < 24) {
      return "Night";
    }
  }

  // Generate Part of Year
  static partOfYear(DateTime n) {
    return DateFormat("MMMMd").format(n);
  }


  // Get Time Since Record in Readable Text
  timeSince(DateTime main) {
    // Variables
    var now = DateTime.now();
    var minute = now.add(new Duration(minutes: 1));
    var hour = now.add(new Duration(minutes: 60));
    var day = now.add(new Duration(days: 1));
    var month = now.add(new Duration(days: 31));
    var year = now.add(new Duration(days: 365));

    // Check Minute w/ main object
    if (main.isAfter(minute)) {
      // Check Hour
      if (main.isAfter(hour)) {
        // Check Day
        if (main.isAfter(day)) {
          // Check Month
          if (main.isAfter(month)) {
            // Check Year
            if (main.isAfter(year)) {
              return "More than a year ago.";
            } else {
              // Estimate Number of Months within Year
              var monthsAgo = now.month - main.month;
              return "About " + monthsAgo.toString() + " month's ago.";
            }
          } else {
            // Estimate Number of Days within Month
            var daysAgo = now.day - main.day;
            return "About " + daysAgo.toString() + " day's ago.";
          }
        } else {
          // Estimate Number of Hours within Day
          var hoursAgo = now.hour - main.hour;
          return "About " + hoursAgo.toString() + " hour's ago.";
        }
      } else {
        // Estimate Number of Minutes within Hour
        var minutesAgo = now.minute - main.minute;
        return "About " + minutesAgo.toString() + " minute's ago.";
      }
    } else {
      // Just Created
      return "Less than a minute ago.";
    }
  }
}

class TimeData {
  // MAIN OBJECT
  // ===============
  DateTime main;

  // ACCURACY DATA
  // ===============
  int hour;
  int minute;
  int second;
  int day;
  int month;

  // HISTORICAL DATA
  // ===============
  int year;
  String timeZone;
  String dayPart;
  String yearPart;

  // Constructor (10 Parameters)
  TimeData(
      {this.main,
      this.hour,
      this.minute,
      this.second,
      this.day,
      this.month,
      this.year,
      this.timeZone,
      this.dayPart,
      this.yearPart});

  // Create from Current Data
  factory TimeData.currentData() {
    var now = DateTime.now();

    // Time Object
    return TimeData(
      main: now,
      hour: now.hour,
      minute: now.minute,
      second: now.second,
      day: now.day,
      month: now.month,
      year: now.year,
      timeZone: now.timeZoneName,
      dayPart: TimeUtility.partOfDay(now),
      yearPart: TimeUtility.partOfYear(now),
    );
  }

  // Convert Object to Encodable (11 Parameters)
  toJSONEncodable() {
    var map = {
      // Accuracy
      'timestamp': main,
      'hour': hour,
      'minute': minute,
      'second': second,
      'day': day,
      'month': month,

      // Historical
      'year': year,
      'timeZone': timeZone,
      'dayPart': dayPart,
      'yearPart': yearPart,
    };
    return map;
  }

  // Display Object
  toPrint() {
    var timeMap = this.toJSONEncodable();
    timeMap.forEach((k, v) {
      print("TIME DATA = " + k + " : " + v);
    });
  }
}
