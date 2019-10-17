import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class ContactModel {
  // Seven Fields
   String name;
   String phone;
   String email;
   String snapchat;
   String facebook;
   String twitter;
   String instagram;
   String profile_picture;
   String message;

  // Constructor
  ContactModel({this.name, this.phone, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram, this.profile_picture});

  // Json Decoder
  factory ContactModel.fromJson(Map<dynamic, dynamic> json) {
    return ContactModel(
        phone: json['phone'],
        name: json['name'],
        email: json['email'],
        snapchat: json['snapchat'],
        facebook: json['facebook'],
        twitter: json['twitter'],
        instagram: json['instagram'],
        profile_picture: json['profile_picture']
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
    m['profile_picture'] = profile_picture;
    m['message'] = message;

    return m;
  }

  toContact(){
    // Organize Data
    var nameData = name.split(" ");
    var phones = new List<Item>();
    phones.add(new Item(label: "Mobile", value: phone.toString()));
    var emails = new List<Item>();
    emails.add(new Item(label: "Personal", value: email.toString()));

    // Create Object
    Contact c = new Contact();
    c.givenName = nameData[0];
    c.familyName  = nameData[1];
    c.phones = phones;
    c.emails = emails;
    c.note = message;

    return c;
  }
}



class ContactList {
    List<ContactModel> items;

  ContactList() {
    items = new List();
  }

  add(ContactModel value){
    items.add(value);
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}