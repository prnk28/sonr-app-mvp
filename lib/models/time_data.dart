
import 'package:sonar_app/utils/utils.dart';

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
  factory TimeData.current() {
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
      'timestamp': main.toString(),
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
    var locMap = this.toJSONEncodable();
    locMap.forEach((k,v) {
      var ks = k.toString();
      var vs = v.toString();
      print("LOCATION DATA = " + ks + " : " + vs);
    });
  }
}
