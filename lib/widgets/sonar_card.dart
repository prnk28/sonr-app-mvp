import 'package:flutter/material.dart';

class SonarCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
        width: 325,
        height: 400,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/contact");
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
              children: [
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
                  padding: EdgeInsets.only(top: 10)),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(child: Text("Firstname",
                    style: TextStyle(
                    fontFamily: "CooperHewitt",
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  )),
                padding: EdgeInsets.only(top: 8, right: 5)),
                Padding(child: Text("Lastname",
                    style: TextStyle(
                    fontFamily: "CooperHewitt",
                    fontWeight: FontWeight.w100,
                    fontSize: 26
                  )),
                padding: EdgeInsets.only(top: 8))
            ]),
            Center(
              child: Padding(child: Text("A short Description Describing where you met this Person.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontFamily: "CooperHewitt",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                  )),
                padding: EdgeInsets.only(top: 5, left: 40, right: 40, bottom: 5))),
            ListTile(
              title: Text('Virginia, US',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: "CooperHewitt",)),
              leading: Icon(
                Icons.pin_drop,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: Text('703-124-3134',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: "CooperHewitt",)),
              leading: Icon(
                Icons.phone,
                color: Colors.blue[500],
              ),
            ),
            Padding(child: Divider(), padding: EdgeInsets.only(top: 0)),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Twitter
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(56,161,243,1),
                child: Image.asset("assets/images/twitter-64.png",
                width: 32, height: 32, color: Color.fromRGBO(255,255,255, 0.85)),
                onPressed: () => {},
              )),
              // Facebook
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(66,103,178,1),
                child: Image.asset("assets/images/facebook-64.png",
                 width: 32, height: 32, color: Color.fromRGBO(255,255,255, 0.85)),
                onPressed: () => {},
              )),
              // Snapchat
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor:  Color.fromRGBO(255,252,0,1),
                child: Image.asset("assets/images/snapchat-64.png", 
                width: 32, height: 32, color: Color.fromRGBO(255,255,255, 1)),
                onPressed: () => {},
              )),
              // Instagram
              Padding(
                padding: EdgeInsets.only(left: 8, top: 0, right: 8, bottom: 8),
                  child: FloatingActionButton(
                backgroundColor:  Color.fromRGBO(35,31,32,1),
                child: Image.asset("assets/images/instagram-64.png",
                 width: 32, height: 32, color: Color.fromRGBO(255,255,255, 0.95)),
                onPressed: () => {},
              ))
            ])
          ])),
        ));
  }
}
