import 'dart:convert';
class ProfileModel {
  bool valuesSet;
   String phone;
   String name;
   String email;
   String snapchat;
   String facebook;
   String twitter;
   String instagram;

  ProfileModel({this.phone, this.name, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram});

  factory ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    return ProfileModel(
        phone: json['phone'],
        name: json['name'],
        email: json['email'],
        snapchat: json['snapchat'],
        facebook: json['facebook'],
        twitter: json['twitter'],
        instagram: json['instagram']
    );
  }

  factory ProfileModel.blank() {
    // Return Blank
    return ProfileModel(
        phone: "",
        name: "",
        email: "",
        snapchat: "",
        facebook: "",
        twitter: "",
        instagram: ""
    );
  }

  // JSON Encoder
   toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['phone'] = phone;
    m['email'] = email;
    m['snapchat'] = snapchat;
    m['facebook'] = facebook;
    m['twitter'] = twitter;
    m['instagram'] = instagram;

    return m;
  }

  bool isEmpty(){
    if (phone == "" &&
        name == "" &&
        email == "" &&
        snapchat == "" &&
        facebook == "" &&
        twitter == "" &&
        instagram == "") {
      return true;
    }
    return false;
  }
}