import 'package:sonar_app/core/core.dart';

class Contact {
  final String id = uuid.v1();
  final String firstName;
  final String lastName;
  final String profilePic;
  final String phone;
  final String snapchat;
  final String facebook;
  final String instagram;
  final String twitter;
  final String linkedin;
  final String email;
  final String website;

  Contact(
      {this.firstName,
      this.lastName,
      this.profilePic,
      this.phone,
      this.snapchat,
      this.facebook,
      this.instagram,
      this.twitter,
      this.linkedin,
      this.email,
      this.website});

  // ** Method to return map **
  toMap() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "profilePic": this.profilePic,
      "phone": this.phone,
      "snapchat": this.snapchat,
      "facebook": this.facebook,
      "instagram": this.instagram,
      "twitter": this.twitter,
      "linkedin": this.linkedin,
      "email": this.email,
      "website": this.website,
    };
  }
}
