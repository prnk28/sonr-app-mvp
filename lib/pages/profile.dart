import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/widgets/profile_picture.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  // Storage Information
  final LocalStorage storage = new LocalStorage('sonar_app');
  ProfileModel _profile = new ProfileModel();
  bool initialized = false;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final snapchatController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();

  // Profile Link
  String profile_link;

  @override
  void initState() {
    super.initState();
    // Get Profile from Disk
    setState(() {
      // Create new item from Storage
      var item = storage.getItem('user_profile');

      if (item != null) {
        // Set Profile Object
        _profile = new ProfileModel(
            name: item['name'],
            phone: item['phone'],
            email: item['email'],
            facebook: item['facebook'],
            twitter: item['twitter'],
            snapchat: item['snapchat'],
            instagram: item['instagram']);

        // Update Controller Text
        phoneController.text = _profile.phone;
        nameController.text = _profile.name;
        emailController.text = _profile.email;
        snapchatController.text = _profile.snapchat;
        facebookController.text = _profile.facebook;
        twitterController.text = _profile.twitter;
        instagramController.text = _profile.instagram;
      }
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    snapchatController.dispose();
    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!initialized) {
            var item = storage.getItem('user_profile');

            if (item != null) {
              _profile = new ProfileModel(
                  name: item['name'],
                  phone: item['phone'],
                  email: item['email'],
                  facebook: item['facebook'],
                  twitter: item['twitter'],
                  snapchat: item['snapchat'],
                  instagram: item['instagram'],
                  profile_picture: item['profile_picture']);
            }
            initialized = true;
          }
          return Drawer(
              elevation: 0.5,
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                DrawerHeader(
                  child: ProfilePicture(profile: _profile),
                  decoration: BoxDecoration(color: Colors.white54),
                ),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            contentPadding:
                                new EdgeInsets.symmetric(vertical: 15.0),
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
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.phone = val)),
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.email = val)),
                      TextFormField(
                          controller: snapchatController,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.snapchat = val)),
                      TextFormField(
                          controller: facebookController,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.facebook = val)),
                      TextFormField(
                          controller: twitterController,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.twitter = val)),
                      TextFormField(
                          controller: instagramController,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 15.0),
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
                          onSaved: (val) =>
                              setState(() => _profile.instagram = val)),
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
        });
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
                storage.setItem('user_profile', _profile.toJSONEncodable());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
