class ContactModel {
  // Seven Fields
   String name;
   String phone;
   String email;
   String snapchat;
   String facebook;
   String twitter;
   String instagram;

  // Constructor
  ContactModel({this.name, this.phone, this.email, this.snapchat,
   this.facebook, this.twitter, this.instagram});

  // Json Decoder
  factory ContactModel.fromJson(Map<dynamic, dynamic> json) {
    return ContactModel(
        phone: json['phone'],
        name: json['name'],
        email: json['email'],
        snapchat: json['snapchat'],
        facebook: json['facebook'],
        twitter: json['twitter'],
        instagram: json['instagram']
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
}

class ContactList {
    List<ContactModel> items;

  ContactList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}