import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthDialog extends StatelessWidget {
  final String document;
  AuthDialog({Key key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("active-transactions")
          .document(document)
          .snapshots(),
      builder: (context, snap) {
        if (snap.data != null) {
          if (snap.data["status"] == 200) {
            return buildMatch(context, snap);
          } else if (snap.data["status"] == 404) {
            return buildLoad(context);
          }
          return Container();
        }
        return Container();
      },
    );
  }

  Widget buildMatch(BuildContext context, AsyncSnapshot snap) {
    String name = snap.data["firstUserData"]["name"];
    var nameData = name.split(" ");

    return Container(
        color: Colors.black54,
        child: Padding(
            padding:
                EdgeInsets.only(top: 150, bottom: 360, left: 65, right: 65),
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
                        padding: EdgeInsets.only(top: 10)),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            child: Text(nameData[0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                )),
                            padding: EdgeInsets.only(top: 8, right: 5)),
                        Padding(
                            child: Text(nameData[1],
                                style: TextStyle(
                                    fontWeight: FontWeight.w100, fontSize: 26)),
                            padding: EdgeInsets.only(top: 8))
                      ]),
                  Center(
                      child: Padding(
                          child: Text(
                              "A short Description Describing where you met this Person.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 14)),
                          padding: EdgeInsets.only(
                              top: 5, left: 40, right: 40, bottom: 5))),
                  Padding(child: Divider(), padding: EdgeInsets.only(top: 0)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // Twitter
                        RawMaterialButton(
                          constraints: BoxConstraints.tight(Size(84, 42)),
                          onPressed: () {
                            //Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 2.0,
                          fillColor: Colors.red,
                          padding: EdgeInsets.all(8),
                        ),

                        // Facebook
                        RawMaterialButton(
                          onPressed: () {},
                          constraints: BoxConstraints.tight(Size(84, 42)),
                          child: Text("Confirm!"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 2.0,
                          fillColor: Colors.green,
                          padding: EdgeInsets.all(8),
                        ),
                      ])
                ]))));
  }

  Widget buildLoad(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: Padding(
            padding:
                EdgeInsets.only(top: 150, bottom: 360, left: 65, right: 65),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SpinKitRotatingCircle(
                  color: Colors.red,
                  size: 50.0,
                ))));
  }
}
