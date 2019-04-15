// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sonar_frontend/pages/contact.dart';
import 'package:sonar_frontend/pages/home.dart';
import 'package:sonar_frontend/pages/profile.dart';

// One simple action: Increment
enum Actions { UpdateDocument, AuthorizeYes, AuthorizeNo, DeleteDocument }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
DocumentCallback updateDocument(DocumentCallback document, dynamic newDocument) {
  DocumentCallback doc = new DocumentCallback(newDocument.documentId, newDocument.status);
  return document = doc;
}

class Sonar extends StatelessWidget {
  final Store<DocumentCallback> store;
  const Sonar({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<DocumentCallback>(
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
                ProfilePage(),
            '/contact': (context) => ContactPage(),
          },
        ));
  }
}

void main() {
  // Redux Store

Store<DocumentCallback> store = new Store<DocumentCallback>(updateDocument, initialState: DocumentCallback("null", 0));
  // Run App
  runApp(Sonar(store: store));
}

class DocumentCallback{
  final String documentId;
  final int status;

  DocumentCallback(this.documentId, this.status);
}
