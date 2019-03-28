import 'package:flutter/material.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/pages/profile.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

class ProfileCard extends StatefulWidget {
  final ProfileStorage profileStorage;

  const ProfileCard({Key key, this.profileStorage}) : super(key: key);
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

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
    return SizedBox(
        height: 256,
        width: 350,
        child: new GestureDetector(
            onVerticalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity < 0) {
                print("Drag was Upward");
              } else {
                print("Drag was Downward");
              }
              print("vertical drag:  $details");
            },
            onTap: _navigateProfile,
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(_profile.name,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text('Name'),
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue[500],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(_profile.phone,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text('Phone'),
                    leading: Icon(
                      Icons.contact_phone,
                      color: Colors.blue[500],
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(_profile.email),
                    subtitle: Text('E-Mail'),
                    leading: Icon(
                      Icons.contact_mail,
                      color: Colors.blue[500],
                    ),
                  ),
                ],
              ),
            )));
  }
  _navigateProfile () async {
              // Navigate to the second screen using a named route
              ProfileModel value = await Navigator.push(
        context,
        MaterialPageRoute<ProfileModel>(
            builder: (BuildContext _) => ProfilePage(profileStorage: ProfileStorage())));
    setState(() {
      if(value !=null){
        _profile = value;
      }
    });
  }
   //_callSonarRequest(GestureLongDr) {}
}
