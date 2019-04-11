import 'dart:convert';
import 'package:pref_dessert/pref_dessert.dart';
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

class ContactModel {
   String name;
   String phone;
   String email;
   String snapchat;
   String facebook;
   String twitter;
   String instagram;

  ContactModel(this.name, this.phone, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram);
}

class ContactModelDesSer extends DesSer<ContactModel>{
  @override
  ContactModel deserialize(String s) {
    var split = s.split(",");
    return new ContactModel(split[0], split[1], split[2], split[3], split[4], split[5], split[6]);
  }

  @override
  String serialize(ContactModel t) {
    return "${t.name},${t.phone},${t.email},${t.snapchat},${t.facebook},${t.twitter},${t.instagram}";
  }

  @override
  // TODO: implement key
  String get key => null;

}