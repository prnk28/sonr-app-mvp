import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

class Contact {
  String id;
  String firstName;
  String lastName;
  String profilePic;
  String phone;
  String snapchat;
  String facebook;
  String instagram;
  String twitter;
  String linkedin;
  String email;
  String website;
  DateTime lastContact;

  Contact() {
    var uuid = Uuid();
    id = uuid.v1();
  }

  // ** Method to Print Model **
  read() {
    // Create Contact Map
    var contactMap = {
      "First Name": this.firstName,
      "Last Name": this.lastName,
      "Profile Pic": this.profilePic,
      "Phone": this.phone,
      "Snapchat": this.snapchat,
      "Facebook": this.facebook,
      "Instagram": this.instagram,
      "Twitter": this.twitter,
      "Linkedin": this.linkedin,
      "Email": this.email,
      "Website": this.website,
      "Last Contact": this.lastContact,
    };

    log.i("Contact #" + this.id);
    print(contactMap.toString());
  }
}
