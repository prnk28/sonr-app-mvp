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
  ProfileModel _profile;

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
      height: 250,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
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
                padding: EdgeInsets.only(top: 10)),
          ]),
          Padding(
                child: Text(getGreeting(_profile.name),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      color: Colors.white
                    )),
                padding: EdgeInsets.only(left: 10, top: 15)),
        Padding(
              child: Text("There are 5k Users with Sonar in your Area.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54
                    )),
              padding: EdgeInsets.only(top: 10)),
          Padding(
              child: Text("You have X Sonars not in your Contacts. Tap to Add.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54
                    )),
              padding: EdgeInsets.only(top: 5))
        ],
      ),
    );
  }
}
