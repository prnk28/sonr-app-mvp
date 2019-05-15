import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/model/contact_model.dart';

class AuthDialog extends StatelessWidget {
  // Storage Parameters
  ContactList list = new ContactList();
  LocalStorage storage = new LocalStorage('sonar_app');

  // Server Parameters
  final DocumentCallback document;
  int userPosition = 0;
  AuthDialog({Key key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return Container();
  }

  Widget buildMatch(BuildContext context, AsyncSnapshot snap) {
    var userData;

    if (userPosition == 1) {
      userData = snap.data["secondUserData"];
    } else {
      userData = snap.data["firstUserData"];
    }

    String name = userData["name"];
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
                                        userData["profile_picture"])))),
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
                          onPressed: () {
                            
                          },
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
                child: Stack(
                  children:<Widget>[
                     SpinKitHourGlass(color: Colors.blue,size: 50.0),
                  Padding(
                  padding: EdgeInsets.only(top: 0, left: 215),
                  child: Tooltip(
                      message: "Cancel",
                      child: RawMaterialButton(
                            constraints: BoxConstraints.tight(Size(28, 28)),
                            onPressed: () {
                              
                            },
                            child: Icon(Icons.close,
                                color: Colors.red, size: 28),
                            shape: new CircleBorder(),
                            elevation: 0,
                            fillColor: Colors.transparent,
                            padding: EdgeInsets.all(8),
                          ))),
                  ]))));
  }

  _saveContact(ContactModel m){
      list.items.add(m);
      print("Contact Length: " + list.items.length.toString());
      _saveToStorage();
  }

   _saveToStorage() {
    storage.setItem('contact_items', list.toJSONEncodable());

    // Call Cloud Function
    
  }
}
