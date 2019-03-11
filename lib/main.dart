// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io' show Platform;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonar Barebones',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
        title: 'Sonar Barebones',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final snapchatController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();
  var registrationToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    snapchatController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  void pushData(Position position) async {
    print("Data Pushed");
    // Set Parameters
    var uuid = new Uuid();
    var transaction = uuid.v1();
    var doc = uuid.v4();

    // Push to Firestore
    Firestore.instance
        .collection('active-transactions')
        .document(doc)
        .setData({
      'created': DateTime.now(),
      'device': device(),
      'email': emailController.text,
      'facebook': facebookController.text,
      'instagram': instagramController.text,
      'location': GeoPoint(position.latitude, position.longitude),
      'name': nameController.text,
      'phone': phoneController.text,
      'snapchat': snapchatController.text,
      'twitter': twitterController.text,
      'transactionID': transaction
    });

    // Call Match Function
    callMatch(transaction, doc);
  }

  Future callRecycle(String transactionID) async {
    try {
      final dynamic resp = await CloudFunctions.instance.call(
        functionName: 'recycleTransaction',
        parameters: <String, dynamic>{
          'transactionID': transactionID,
        },
      );
      print("Response: " + resp);
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

    Future callMatch(String transactionId, String docId) async {
    try {
      final dynamic resp = await CloudFunctions.instance.call(
        functionName: 'matchRequest',
        parameters: <String, dynamic>{
          'transactionID': transactionId,
          'documentID' : docId
        },
      );
      print("Response: " + resp);
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
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
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(hintText: 'Phone'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: snapchatController,
            decoration: InputDecoration(hintText: 'Snapchat'),
          ),
          TextField(
            controller: facebookController,
            decoration: InputDecoration(hintText: 'Facebook'),
          ),
          TextField(
            controller: twitterController,
            decoration: InputDecoration(hintText: 'Twitter'),
          ),
          TextField(
            controller: instagramController,
            decoration: InputDecoration(hintText: 'Instagram'),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.publish),
            onPressed: () async {
              GeolocationStatus geolocationStatus =
                  await Geolocator().checkGeolocationPermissionStatus();

              if (geolocationStatus == GeolocationStatus.granted) {
                pushData(await Geolocator().getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high));
              } else {
                await PermissionHandler()
                    .requestPermissions([PermissionGroup.locationWhenInUse]);
              }
            }));
  }

  // Helper Method
  String device() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return '';
    }
  }
}
