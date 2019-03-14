
import 'package:flutter/material.dart';
import 'package:sonar_frontend/widgets/sonar_button.dart';

class UserFormPage extends StatefulWidget {
  UserFormPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserFormPage> {
  _UserFormState();

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

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final snapchatController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();
  Map<String, dynamic> controllerValues = {
    'name': "",
    'phone': "",
    'email': "",
    'snapchat': "",
    'facebook': "",
    'twitter': "",
    'instagram': "",
  };

  // State Change Method
  void _handleControllerChange(Map) {
    setState(() {
      controllerValues = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'snapchat': snapchatController.text,
        'facebook': facebookController.text,
        'twitter': twitterController.text,
        'instagram': instagramController.text,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
        ]),
        floatingActionButton: SonarButton(
            userData: controllerValues, onSend: _handleControllerChange));
  }
}