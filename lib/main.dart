// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sonar_frontend/pages/contact.dart';
import 'package:sonar_frontend/pages/home.dart';
import 'package:sonar_frontend/pages/profile.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

// One simple action: Increment
enum Actions { UpdateDocument, AuthorizeYes, AuthorizeNo, DeleteDocument }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
String updateDocument(String document, dynamic newDocument) {
  return document = newDocument;
}

class Sonar extends StatelessWidget {
  final Store<String> store;
  const Sonar({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<String>(
        store: store,
        child: MaterialApp(
          title: 'Sonar',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          routes: <String, WidgetBuilder>{
            '/': (context) => HomePage(),
            '/profile': (context) =>
                ProfilePage(profileStorage: ProfileStorage()),
            '/contact': (context) => ContactPage(),
          },
        ));
  }
}

void main() {
  // Redux Store

Store<String> store = new Store<String>(updateDocument, initialState: "null");

  // Run App
  runApp(Sonar(store: store));
}
