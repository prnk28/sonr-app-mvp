class ContactModel {
   bool valuesSet;
   String phone;
   String name;
   String email;
   String snapchat;
   String facebook;
   String twitter;
   String instagram;
   String profilePicture;

  ContactModel({this.phone, this.name, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram, this.profilePicture});

  factory ContactModel.fromJson(Map<dynamic, dynamic> json) {
    return ContactModel(
        phone: json['phone'],
        name: json['name'],
        email: json['email'],
        snapchat: json['snapchat'],
        facebook: json['facebook'],
        twitter: json['twitter'],
        instagram: json['instagram'],
        profilePicture: json['profile_picture']
    );
  }

  factory ContactModel.blank() {
    return ContactModel(
        phone: "",
        name: "",
        email: "",
        snapchat: "",
        facebook: "",
        twitter: "",
        instagram: "",
        profilePicture: ""
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
    m['profile_picture'] = profilePicture;

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