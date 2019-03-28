import 'dart:convert';

class ProfileModel {
  bool valuesSet;
  final String phone;
  final String name;
  final String email;
  final String snapchat;
  final String facebook;
  final String twitter;
  final String instagram;

  ProfileModel({this.phone, this.name, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
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

  toJson() {
    return {
      'phone': this.phone,
      'name': this.name,
      'email': this.email,
      'snapchat': this.snapchat,
      'facebook': this.facebook,
      'twitter': this.twitter,
      'instagram': this.instagram,
    };
  }

  String toString(){
    return json.encode(this);
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