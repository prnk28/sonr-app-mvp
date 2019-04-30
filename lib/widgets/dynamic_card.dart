import 'package:flutter/material.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sonar_frontend/utils/content_builder.dart';
import 'dart:math' as math;

class DynamCard extends StatelessWidget {
  final ContactModel profile;
  final double offset;

  const DynamCard({Key key, this.profile, this.offset}) : super(key: key);

  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
          margin: EdgeInsets.only(left: 6, right: 6, bottom: 24),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(children: [
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  child: Image.asset(
                    'assets/images/steve-johnson.jpeg',
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
                                  image: CachedNetworkImageProvider(
                                      profile.profile_picture)))),
                      padding: EdgeInsets.only(top: 10)),
                ),
                DynamCardContent(profile: profile, offset: gauss)
              ],
            ),
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
    return Padding(
        padding: EdgeInsets.only(top: 140),
        child: Column(children: [
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
                padding: EdgeInsets.only(top: 8, right: 5)),
            Padding(
                child: Transform.translate(
                  offset: Offset(24 * offset, 0),
                  child: Text(
                      ContentBuilder.getNamePart(NamePart.LastName, profile),
                      style:
                          TextStyle(fontWeight: FontWeight.w100, fontSize: 26)),
                ),
                padding: EdgeInsets.only(top: 8))
          ]),
          Center(
              child: Padding(
                  child: Text(profile.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100,
                          fontSize: 14)),
                  padding:
                      EdgeInsets.only(top: 5, left: 40, right: 40, bottom: 5))),
          ListTile(
            title: Text('Virginia, US',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                )),
            leading: Icon(
              Icons.pin_drop,
              color: Colors.blue[500],
            ),
          ),
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
          Padding(child: Divider(), padding: EdgeInsets.only(top: 0)),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Twitter
                Transform.translate(
                    offset: Offset(7 * offset, 0),
                    child: RawMaterialButton(
                      constraints: BoxConstraints.tight(Size(42, 42)),
                      onPressed: () {},
                      child: Image.asset("assets/images/twitter-64.png",
                          height: 32, width: 32),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Color.fromRGBO(56, 161, 243, 1),
                      padding: EdgeInsets.all(8),
                    )),

                // Facebook
                Transform.translate(
                    offset: Offset(14 * offset, 0),
                    child: RawMaterialButton(
                      onPressed: () {},
                      constraints: BoxConstraints.tight(Size(42, 42)),
                      child: Image.asset("assets/images/facebook-64.png",
                          height: 32, width: 32),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Color.fromRGBO(66, 103, 178, 1),
                      padding: EdgeInsets.all(8),
                    )),

                // Snapchat
                Transform.translate(
                    offset: Offset(21 * offset, 0),
                    child: RawMaterialButton(
                      onPressed: () {},
                      constraints: BoxConstraints.tight(Size(42, 42)),
                      child: Image.asset("assets/images/snapchat-64.png",
                          height: 32, width: 32),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Color.fromRGBO(255, 252, 0, 1),
                      padding: EdgeInsets.all(8),
                    )),

                // Instagram
                Transform.translate(
                    offset: Offset(28 * offset, 0),
                    child: RawMaterialButton(
                      onPressed: () {},
                      constraints: BoxConstraints.tight(Size(42, 42)),
                      child: Image.asset("assets/images/instagram-64.png",
                          height: 32, width: 32),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Color.fromRGBO(35, 31, 32, 1),
                      padding: EdgeInsets.all(8),
                    )),
              ])
        ]));
  }
}
