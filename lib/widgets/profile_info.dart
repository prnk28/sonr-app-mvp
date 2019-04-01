import 'package:flutter/material.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/info_builder.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

class ProfileInfo extends StatefulWidget {
  final ProfileStorage profileStorage;

  const ProfileInfo({Key key, this.profileStorage}) : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  // User Disk Reference
  ProfileModel _profile;

  // Top Widget Spacing
  double topPadding = 55;

  @override
  void initState() {
    super.initState();
    widget.profileStorage.readProfile().then((ProfileModel value) {
      setState(() {
        _profile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 285,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            // User Picture
            Padding(
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                new NetworkImage("http://i.pravatar.cc/100")))),
                padding: EdgeInsets.only(top: topPadding)),
            // Greeting
            Padding(
                child: Text(getGreeting(_profile.name),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 32,
                        color: Colors.white)),
                padding: EdgeInsets.only(top: topPadding, left: 10)),
          ]),
          // Users in your Area
          Padding(
              child: Text("There are 5k Users with Sonar in your Area.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Colors.white54)),
              padding: EdgeInsets.only(top: 15)),
          // Extra Information
          Padding(
              child: Text("You have X Sonars not in your Contacts.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Colors.white54)),
              padding: EdgeInsets.only(top: 5)),
              // Current Details
          Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.today, color: Colors.white70),
                  Text("April 1, 2019", style: TextStyle(
                      color: Colors.white70)),
                  Text(" | ", style: TextStyle(
                      color: Colors.white70)),
                  Icon(Icons.pin_drop, color: Colors.white70),
                  Text("Richmond, US", style: TextStyle(
                      color: Colors.white70)),
                ],
              ),
              padding: EdgeInsets.only(top: 55))
        ],
      ),
    );
  }
}
