import 'package:flutter/material.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

class ProfilePage extends StatefulWidget {
  final ProfileStorage profileStorage;
  ProfilePage({Key key, this.title, this.profileStorage}) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  ProfileModel _profile;

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final snapchatController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get Profile from Disk
    widget.profileStorage.readProfile().then((ProfileModel value) {
      setState(() {
        _profile = value;
        // Check if Profile is Empty
        if (!_profile.isEmpty()) {
          phoneController.text = _profile.phone;
          nameController.text = _profile.name;
          emailController.text = _profile.email;
          snapchatController.text = _profile.snapchat;
          facebookController.text = _profile.facebook;
          twitterController.text = _profile.twitter;
          instagramController.text = _profile.instagram;
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up Controllers
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    snapchatController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                _updateProfile();
                // Write to Disk
                widget.profileStorage.writeProfile(_profile);
                Navigator.pop(context, _profile);
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Name')),
          TextField(
              controller: phoneController,
              decoration: InputDecoration(hintText: 'Phone')),
          TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email')),
          TextField(
              controller: snapchatController,
              decoration: InputDecoration(hintText: 'Snapchat')),
          TextField(
              controller: facebookController,
              decoration: InputDecoration(hintText: 'Facebook')),
          TextField(
              controller: twitterController,
              decoration: InputDecoration(hintText: 'Twitter')),
          TextField(
              controller: instagramController,
              decoration: InputDecoration(hintText: 'Instagram')),
        ]));
  }

  void _updateProfile() {
    // Get Values
    var jsonMap = {
      'phone': phoneController.text,
      'name': nameController.text,
      'email': emailController.text,
      'snapchat': snapchatController.text,
      'facebook': facebookController.text,
      'twitter': twitterController.text,
      'instagram': instagramController.text
    };

    // Set Values
    _profile = ProfileModel.fromJson(jsonMap);
  }
}
