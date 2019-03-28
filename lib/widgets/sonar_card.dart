import 'package:flutter/material.dart';

class SonarCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
        width: 325,
        height: 355,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/contact");
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(children: [
            Center(
              child: Padding(
                  child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                  "http://i.pravatar.cc/100")))),
                  padding: EdgeInsets.only(top: 15)),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(child: Text("Firstname",
                    style: TextStyle(
                    fontFamily: "CooperHewitt",
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  )),
                padding: EdgeInsets.only(top: 8, right: 5)),
                Padding(child: Text("Lastname",
                    style: TextStyle(
                    fontFamily: "CooperHewitt",
                    fontWeight: FontWeight.w100,
                    fontSize: 28
                  )),
                padding: EdgeInsets.only(top: 8))
            ]),
            ListTile(
              title: Text('703-124-3134',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              leading: Icon(
                Icons.phone,
                color: Colors.blue[500],
              ),
            ),
            Padding(child: Divider(), padding: EdgeInsets.only(top: 40)),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Twitter
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () => {},
              )),
              // Facebook
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () => {},
              )),
              // Snapchat
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () => {},
              )),
              // Instagram
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Colors.lightBlue,
                onPressed: () => {},
              ))
            ])
          ])),
        ));
  }
}
