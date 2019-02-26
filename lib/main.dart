// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tabs_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Analytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(
        title: 'Firebase Analytics Demo',
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

  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

void _pushData(){
  Firestore.instance.collection('books').document()
  .setData({ 'title': 'title', 'author': 'author' });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          MaterialButton(
            child: const Text('Push Data'),
            onPressed: _pushData,
          )]
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.tab),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<TabsPage>(
                settings: const RouteSettings(name: TabsPage.routeName),
                builder: (BuildContext context) {
                  return TabsPage();
                }));
          }),
    );
  }
}