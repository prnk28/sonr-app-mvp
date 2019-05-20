import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/card_util.dart';
import 'package:sonar_frontend/utils/content_builder.dart';
import 'package:sonar_frontend/utils/location_util.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key key}) : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  // Storage Information
  final LocalStorage storage = new LocalStorage('sonar_app');
  ProfileModel profile = new ProfileModel();
  bool initialized = false;

  // Top Widget Spacing
  double topPadding = 25;

  // Get Text Location
  Future<String> getTextFromLocation() async {
    return await ContentBuilder.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Get Data
          if (!initialized) {
            profile = CardUtility.getProfileModel(storage);
            initialized = true;
          }

          return Container(
            width: 285,
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Greeting
                      Padding(
                          child: Text(ContentBuilder.getGreeting(profile.name),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.today, color: Colors.white70),
                        Text(ContentBuilder.getTodayDate(),
                            style: TextStyle(color: Colors.white70)),
                        Text(" | ", style: TextStyle(color: Colors.white70)),
                        Icon(Icons.pin_drop, color: Colors.white70),
                        Text("Richmond, VA",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 55))
              ],
            ),
          );
        });
  }
}
