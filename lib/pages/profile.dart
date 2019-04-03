import 'package:flutter/material.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/profile_util.dart';

class ProfilePage extends StatefulWidget {
  final ProfileStorage profileStorage;
  ProfilePage({Key key, this.title, this.profileStorage}) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  ProfileModel _profile;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final snapchatController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get Profile from Disk
    widget.profileStorage.readProfile().then((ProfileModel value) {
      setState(() {
        _profile = value;
        // Check if Profile is Empty
        if (!_profile.isEmpty()) {
          phoneController.text = _profile.phone;
          nameController.text = _profile.name;
          emailController.text = _profile.email;
          snapchatController.text = _profile.snapchat;
          facebookController.text = _profile.facebook;
          twitterController.text = _profile.twitter;
          instagramController.text = _profile.instagram;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0.5,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: Center(
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
            decoration: BoxDecoration(color: Colors.white54),
          ),
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                  },
                  onSaved: (val) => setState(() => _profile.name = val),
                ),
                TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Phone',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone';
                      }
                    },
                    onSaved: (val) => setState(() => _profile.phone = val)),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter your email';
                    //   }
                    // },
                    onSaved: (val) => setState(() => _profile.email = val)),
                TextFormField(
                    controller: snapchatController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          IconData(0xebe1, fontFamily: 'Boxicons'),
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter your name';
                    //   }
                    // },
                    onSaved: (val) => setState(() => _profile.snapchat = val)),
                TextFormField(
                    controller: facebookController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          IconData(0xebb2, fontFamily: 'Boxicons'),
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter your name';
                    //   }
                    // },
                    onSaved: (val) => setState(() => _profile.facebook = val)),
                TextFormField(
                    controller: twitterController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          IconData(0xebeb, fontFamily: 'Boxicons'),
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter your name';
                    //   }
                    // },
                    onSaved: (val) => setState(() => _profile.twitter = val)),
                TextFormField(
                    controller: instagramController,
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      border: InputBorder.none,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          IconData(0xebbe, fontFamily: "Boxicons"),
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12.0)),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Please enter your name';
                    //   }
                    // },
                    onSaved: (val) => setState(() => _profile.instagram = val)),
              ])),
          Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 15),
              child: ButtonTheme(
                buttonColor: Colors.red,
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _confirmSave();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.check, color: Colors.white),
                        Padding(
                            child: Text("Save",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            padding: EdgeInsets.only(right: 90))
                      ],
                    )),
              )),
              Divider(),
        ]));
  }

  void _confirmSave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Changes?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Save"),
              onPressed: () {
                _formKey.currentState.save();
                widget.profileStorage.writeProfile(_profile);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
