// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

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
  MyHomePage({Key key, this.title})
      : super(key: key);

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

   // Firebase
   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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

Future<Position> _getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
            hintText: 'Name'
            ),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
            hintText: 'Phone'
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
            hintText: 'Email'
            ),
          ),
          TextField(
            controller: snapchatController,
            decoration: InputDecoration(
            hintText: 'Snapchat'
            ),
          ),
          TextField(
            controller: facebookController,
            decoration: InputDecoration(
            hintText: 'Facebook'
            ),
          ),
          TextField(
            controller: twitterController,
            decoration: InputDecoration(
            hintText: 'Twitter'
            ),
          ),
          TextField(
            controller: instagramController,
            decoration: InputDecoration(
            hintText: 'Instagram'
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.publish),
          onPressed:() {
                // Get Current Location
                _getLocation().then((value) {
                  setState(() {
                    // Set Device
                    var device = '';
                    if (Platform.isAndroid) {
                      device = 'Android';
                    } else if (Platform.isIOS) {
                      device = 'iOS';
                    }
                    // Push to Firestore
                    Firestore.instance.collection('active-transactions').document()
                    .setData(
                      {
                        'name': nameController.text,
                        'phone': phoneController.text,
                        'device': device,
                        'email': emailController.text,
                        'snapchat': snapchatController.text,
                        'facebook': facebookController.text,
                        'instagram': instagramController.text,
                        'twitter': twitterController.text,
                        'userId': _firebaseMessaging.getToken(),
                        'created': DateTime.now(),
                        'location': new GeoPoint(value.latitude, value.longitude)
                      }
                    );
                  });
                });
              },
          ),
    );
  }
}