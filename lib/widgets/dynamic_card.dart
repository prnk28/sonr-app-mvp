import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sonar_frontend/utils/content_builder.dart';
import 'dart:math' as math;

class DynamCard extends StatelessWidget {
  final ContactModel profile;
  final String headerPath;
  final double offset;
  const DynamCard({Key key, this.profile, this.offset, this.headerPath}) : super(key: key);

  Widget build(BuildContext context) {
    // Initialize
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    // Build Widget
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
          margin: EdgeInsets.only(left: 6, right: 6, bottom: 24),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(children: [
            Stack(children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset('$headerPath',
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              Center(
                child: Padding(
                    child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://api.adorable.io/avatars/285/abott@adorable.png")))),
                    padding: EdgeInsets.only(top: 10)),
              ),
              // Export Contact
              Padding(
                  padding: EdgeInsets.only(top: 5, left: 265),
                  child: Tooltip(
                      message: "Save " +
                          ContentBuilder.getNamePart(
                              NamePart.FirstName, profile) +
                          "'s Card to Contacts",
                      child: Transform.translate(
                          offset: Offset(-25 * offset, 0),
                          child: RawMaterialButton(
                            constraints: BoxConstraints.tight(Size(36, 36)),
                            onPressed: () async {
                              if (await CardUtility.addContactToDevice(
                                  profile)) {
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Success!",
                                  desc: "Contact was saved to Phone Book.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "GREAT",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                    )
                                  ],
                                ).show();
                              }
                            },
                            child: Icon(Icons.group_add,
                                color: Colors.white, size: 18),
                            shape: new CircleBorder(),
                            elevation: 4.0,
                            fillColor: Colors.orange,
                            padding: EdgeInsets.all(8),
                          )))),
              Padding(
                  padding: EdgeInsets.only(top: 105),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Call
                        Tooltip(
                            message: "Call " +
                                ContentBuilder.getNamePart(
                                    NamePart.FirstName, profile) +
                                " at " +
                                profile.phone,
                            child: Transform.translate(
                                offset: Offset(10 * offset, 0),
                                child: RawMaterialButton(
                                  constraints:
                                      BoxConstraints.tight(Size(36, 36)),
                                  onPressed: () {},
                                  child: Icon(Icons.phone,
                                      color: Colors.white, size: 18),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.blueGrey,
                                  padding: EdgeInsets.all(8),
                                ))),
                        // Email
                        Tooltip(
                            message: "Email " +
                                ContentBuilder.getNamePart(
                                    NamePart.FirstName, profile) +
                                " at " +
                                profile.email,
                            child: Transform.translate(
                                offset: Offset(25 * offset, 0),
                                child: RawMaterialButton(
                                  constraints:
                                      BoxConstraints.tight(Size(36, 36)),
                                  onPressed: () {},
                                  child: Icon(Icons.email,
                                      color: Colors.white, size: 18),
                                  shape: new CircleBorder(),
                                  elevation: 4.0,
                                  fillColor: Colors.blueGrey,
                                  padding: EdgeInsets.all(8),
                                )))
                      ]))
            ]),
            DynamCardContent(profile: profile, offset: gauss)
          ])),
    );
  }
}

class DynamCardContent extends StatelessWidget {
  final ContactModel profile;
  final double offset;

  const DynamCardContent(
      {Key key, @required this.profile, @required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Padding(
            child: Transform.translate(
                offset: Offset(8 * offset, 0),
                child: Text(
                    ContentBuilder.getNamePart(NamePart.FirstName, profile),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ))),
            padding: EdgeInsets.only(top: 6, right: 5)),
        Padding(
            child: Transform.translate(
              offset: Offset(24 * offset, 0),
              child: Text(
                  ContentBuilder.getNamePart(NamePart.LastName, profile),
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 26)),
            ),
            padding: EdgeInsets.only(top: 6))
      ]),
      Center(
          child: Padding(
              child: Text("Sample Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                      fontSize: 14)),
              padding:
                  EdgeInsets.only(top: 5, left: 40, right: 40, bottom: 5))),
      ListTile(
        title: Text(ContentBuilder.getPhone(profile),
            style: TextStyle(
              fontWeight: FontWeight.w400,
            )),
        leading: Icon(
          Icons.phone,
          color: Colors.blue[500],
        ),
      ),
      ListTile(
        title: Text('http://wwww.example.com',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            )),
        leading: Icon(
          Icons.web,
          color: Colors.blue[500],
        ),
      ),
      ListTile(
        title: Text('City, COUNTRY',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            )),
        leading: Icon(
          Icons.pin_drop,
          color: Colors.blue[500],
        ),
      ),
      Padding(child: Divider(), padding: EdgeInsets.only(top: 2)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        // Twitter
        Tooltip(
            preferBelow: false,
            message: "Open " +
                ContentBuilder.getNamePart(NamePart.FirstName, profile) +
                "'s Twitter",
            child: Transform.translate(
                offset: Offset(7 * offset, 0),
                child: RawMaterialButton(
                  constraints: BoxConstraints.tight(Size(42, 42)),
                  onPressed: () {},
                  child: Image.asset("assets/images/social/twitter-64.png",
                      height: 32, width: 32),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(56, 161, 243, 1),
                  padding: EdgeInsets.all(8),
                ))),

        // Facebook
        Tooltip(
            preferBelow: false,
            message: "Find " +
                ContentBuilder.getNamePart(NamePart.FirstName, profile) +
                " on Facebook",
            child: Transform.translate(
                offset: Offset(14 * offset, 0),
                child: RawMaterialButton(
                  onPressed: () {},
                  constraints: BoxConstraints.tight(Size(42, 42)),
                  child: Image.asset("assets/images/social/facebook-64.png",
                      height: 32, width: 32),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(66, 103, 178, 1),
                  padding: EdgeInsets.all(8),
                ))),

        // Snapchat
        Tooltip(
            preferBelow: false,
            message: "Add " +
                ContentBuilder.getNamePart(NamePart.FirstName, profile) +
                " on Snapchat",
            child: Transform.translate(
                offset: Offset(21 * offset, 0),
                child: RawMaterialButton(
                  onPressed: () {},
                  constraints: BoxConstraints.tight(Size(42, 42)),
                  child: Image.asset("assets/images/social/snapchat-64.png",
                      height: 32, width: 32),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(255, 252, 0, 1),
                  padding: EdgeInsets.all(8),
                ))),

        // Instagram
        Tooltip(
            preferBelow: false,
            message: "Follow " +
                ContentBuilder.getNamePart(NamePart.FirstName, profile) +
                " on Instagram",
            child: Transform.translate(
                offset: Offset(28 * offset, 0),
                child: RawMaterialButton(
                  onPressed: () {},
                  constraints: BoxConstraints.tight(Size(42, 42)),
                  child: Image.asset("assets/images/social/instagram-64.png",
                      height: 32, width: 32),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Color.fromRGBO(35, 31, 32, 1),
                  padding: EdgeInsets.all(8),
                ))),
      ])
    ]);
  }
}
