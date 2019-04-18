import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/main.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

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
    // Set Position
    if(document.status == 404){
      userPosition = 1;
    }

    // Create Stream
    return StreamBuilder(
      stream: Firestore.instance
          .collection("active-transactions")
          .document(document.documentId)
          .snapshots(),
      builder: (context, snap) {
        if (snap.data != null) {
          // On Match
          if (snap.data["status"] == 200) {
            return buildMatch(context, snap);
          }
          // Pending Match
          else if (snap.data["status"] == 404) {
            return buildLoad(context);
          }
          // Cancelled
          else if (snap.data["status"] == 000) {
            print("One user declined");
            _callTransferRecycle(document.documentId);
            return Container();
          }
          // Authorized
          else if (snap.data["status"] == 100) {
            print("Match Confirmed");

            // Write Match to Disk
            if(userPosition == 1){
              // Load Data By Position
              ContactModel contact = new ContactModel.fromJson(snap.data["secondUserData"]);
              _saveContact(contact);

              // Call Cloud Function
            _callTransferRecycle(document.documentId);
              return Center(child:SonarCard(profile: contact));
            }else{
              // Save Data By Position
              ContactModel contact = new ContactModel.fromJson(snap.data["firstUserData"]);
             _saveContact(contact);

              // Call Cloud Function
            _callTransferRecycle(document.documentId);
              return Center(child:SonarCard(profile: contact));
            }
          }
          return Container();
        }
        return Container();
      },
    );
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
                            _cancelAuthorization(document.documentId, userPosition);
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
                            _confirmAuthorization(document.documentId, userPosition);
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
                child: SpinKitHourGlass(
                  color: Colors.blue,
                  size: 50.0,
                ))));
  }

  _callTransferRecycle(String docID) async {
    // Init Parameters
    var params= {"documentID" : docID};

    // Call Request
      await CloudFunctions.instance.call(
          functionName: 'recycleTransferRequest',
          parameters: params
        );
  }

  _confirmAuthorization(doc, userPosition) {
    // Update Doc by User Position
    if (userPosition == 1) {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .get()
          .then((snap) {
        if (snap.data["secondUserConfirmed"] == true) {
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'firstUserConfirmed': true,
            'status': 100
          });
        } else{
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'firstUserConfirmed': true
          });
        }
      });
    } else {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .get()
          .then((snap) {
        if (snap.data["firstUserConfirmed"] == true) {
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'secondUserConfirmed': true,
            'status': 100
          });
        } else{
          Firestore.instance
              .collection('active-transactions')
              .document(doc)
              .updateData({
            'secondUserConfirmed': true
          });
        }
      });
    }
    // Reset userPosition
    userPosition = 0;
  }

  _cancelAuthorization(doc, userPosition) {
    // Update Doc by User Position
    if (userPosition == 1) {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .updateData({'firstUserConfirmed': false, 'status': 000});
    } else {
      Firestore.instance
          .collection('active-transactions')
          .document(doc)
          .updateData({'secondUserConfirmed': false, 'status': 000});
    }
    // Reset userPosition
    userPosition = 0;
  }

  _saveContact(ContactModel m){
      list.items.add(m);
      _saveToStorage();
  }

   _saveToStorage() {
    storage.setItem('contact_items', list.toJSONEncodable());
  }
}
