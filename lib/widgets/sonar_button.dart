import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/model/match_transaction.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

class SonarButton extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final ProfileStorage profileStorage;
  SonarButton({this.onPressed, this.tooltip, this.icon, this.profileStorage});

  @override
  _SonarButtonState createState() => _SonarButtonState();
}

class _SonarButtonState extends State<SonarButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;
  ProfileModel _profile;

  // Match Method
  _pushAndMatchData(BuildContext context) async {
    // Get Location'
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var request = MatchTransaction(_profile, position);
      // Modify UI to Listen to Request
      //matchBuilder(context, request.transactionID);

      // Begin Request with Payload Data
      try {
        final dynamic resp = await CloudFunctions.instance.call(
          functionName: 'matchRequest',
          parameters: request.createTransaction(),
        );
        print(resp);
        // Cloud Fail
      } on CloudFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e.code);
        print(e.message);
        print(e.details);
      } catch (e) {
        print('caught generic exception');
        print(e);
      }
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationWhenInUse]);
    }
  }

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    widget.profileStorage.readProfile().then((ProfileModel value) {
      setState(() {
        _profile = value;
      });
    });
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: () {
          _pushAndMatchData(context);
        },
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _animateIcon,
        ),
      ),
    );
  }

  Widget matchBuilder(BuildContext context, String transactionID) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("active-transactions")
            .document(transactionID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Container(
                child: Text("Loading"),
                width: 400,
                height: 400,
                color: Colors.blue);
          }
          var userDocument = snapshot.data;
          return AlertDialog(
            title: new Text(userDocument["name"]),
          );
        });
  }
}
