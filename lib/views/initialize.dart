import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/views/views.dart';

final _formKey = GlobalKey<FormState>();

class InitializeView extends StatefulWidget {
  // Form Image Data
  final Bloc sonarBloc;

  InitializeView({Key key, this.sonarBloc}) : super(key: key);

  @override
  _InitializeViewState createState() => _InitializeViewState();
}

class _InitializeViewState extends State<InitializeView> {
  File _image;

  List<int> _imageBytes;

  String _firstName;

  String _lastName;

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    await _image.writeAsBytes(_imageBytes);
    print(_imageBytes.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // First Name Label
          Text("First Name",
              style: Design.getTextStyle(TextStyleType.HintText)),

          // First Name Input
          Neumorphic(
              child: TextFormField(
                  // decoration: const InputDecoration(
                  //   floatingLabelBehavior: FloatingLabelBehavior.always,
                  //   hintText: 'Enter your first name',
                  // ),
                  validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid First Name';
                }
                return null;
              }, onChanged: (String value) {
                this._firstName = value;
              }),
              style: Design.textFieldStyle),

          // Last Name Label
          Text("Last Name", style: Design.getTextStyle(TextStyleType.HintText)),

          // Last Name Input
          Neumorphic(
              child: TextFormField(
                  // decoration: const InputDecoration(
                  //   floatingLabelBehavior: FloatingLabelBehavior.always,
                  //   hintText: 'Enter your last name',
                  // ),
                  validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter valid Last Name';
                }
                return null;
              }, onChanged: (String value) {
                this._lastName = value;
              }),
              style: Design.textFieldStyle),
          RaisedButton(
            onPressed: getImage,
            child: Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // Process data.
                  widget.sonarBloc.add(Initialize(
                      userProfile: new Profile(
                          this._firstName, this._lastName, this._imageBytes)));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
