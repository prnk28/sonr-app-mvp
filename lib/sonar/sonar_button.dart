import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/model/match_transaction.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/sonar/sonar_box.dart';
import 'package:sonar_frontend/sonar/sonar_communication.dart';
import 'package:sonar_frontend/utils/location_util.dart';
import 'package:sonar_frontend/utils/time_util.dart';

class SonarButton extends StatefulWidget {

  @override
  _SonarButtonState createState() => _SonarButtonState();
}

class _SonarButtonState extends State<SonarButton>
    with SingleTickerProviderStateMixin {
  // Animation Variables
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;

  // Storage Information
  final LocalStorage storage = new LocalStorage('sonar_app');
  ProfileModel _profile = new ProfileModel();
  bool initialized = false;
  bool requestCalled = false;
  DocumentCallback document;

  // Match Method
  _pushAndMatchData(BuildContext context, VoidCallback callback) async {
    // Get Location'
    if (await LocationUtility.activeLocationPermission() && !requestCalled) {
      // Generate Request Data
      LocationData location = await LocationUtility.createLocationData();
      TimeData time = TimeData.current();
      location.toPrint();
      time.toPrint();

      // Request Model
      var request = MatchTransaction(_profile, location, time).toJSONEncodable();
      var data = _profile.toJSONEncodable();

      // Send Request
      sonar.sendRequest(data, request);

      // Present Sonar Window
      showDialog(
        context: context,
        builder: (BuildContext context) => SonarBox(
              title: "Success",
              description:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              buttonText: "Okay",
              requestData: request,
              userData: data,
            ),
      );
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
    return new StoreConnector<DocumentCallback, VoidCallback>(
      converter: (store) {
        return () => store.dispatch(document);
      },
      builder: (context, callback) {
        return FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // Wait for Data
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Initialize Data
              if (!initialized) {
                var item = storage.getItem('user_profile');

                if (item != null) {
                  _profile = new ProfileModel(
                      name: item['name'],
                      phone: item['phone'],
                      email: item['email'],
                      facebook: item['facebook'],
                      twitter: item['twitter'],
                      snapchat: item['snapchat'],
                      instagram: item['instagram'],
                      profile_picture: item['profile_picture']);
                } else {
                  _profile = new ProfileModel.blank();
                }
                initialized = true;
              }

              return Container(
                child: FloatingActionButton(
                  backgroundColor: _buttonColor.value,
                  onPressed: () {
                    _pushAndMatchData(context, callback);
                  },
                  tooltip: 'Request Sonar',
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_arrow,
                    progress: _animateIcon,
                  ),
                ),
              );
            });
      },
    );
  }
}
