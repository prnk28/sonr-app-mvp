import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/widgets/dynamic_card.dart';

class CardUtility {
  // Export Card to Device
  static addContactToDevice(ContactModel item) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.granted) {
      var newContact = item.toContact();
      await ContactsService.addContact(newContact);
      return true;
    } else {
      await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    }
  }

  // Creates DynamCard Widget List given data, offset
  static createCardWidgets(list, pageOffset) {
    // Init Cards
    List<Widget> cards = new List<Widget>();

    // Iterate List
    if (list.items.length > 0) {
      for (var i = 0; i < list.items.length; i++) {
        cards.add(DynamCard(profile: list.items[i], offset: pageOffset - i));
      }
    }
    return cards;
  }

  // Accesses Storage to Return Contacts as Defined Model
  static getContactModelList(storage) {
    // Initialization
    ContactList contactList = new ContactList();

    // Get Items
    var items = storage.getItem('contact_items');
    if (items != null) {
      (items as List).forEach((item) {
        print(item['name']);
        final contact = new ContactModel(
          name: item['name'],
          phone: item['phone'],
          email: item['email'],
          facebook: item['facebook'],
          twitter: item['twitter'],
          snapchat: item['snapchat'],
          instagram: item['instagram'],
          profile_picture: item['profile_picture'],
        );
        contact.message = item["message"];
        contactList.add(contact);
      });
    }
    // Return
    return contactList;
  }

  static getProfileModel(storage) {
    // Initialization
    var item = storage.getItem('user_profile');
    ProfileModel profile;

    // Get Profile Data
    if (item != null) {
      profile = new ProfileModel(
          name: item['name'],
          phone: item['phone'],
          email: item['email'],
          facebook: item['facebook'],
          twitter: item['twitter'],
          snapchat: item['snapchat'],
          instagram: item['instagram'],
          profile_picture: item['profile_picture']);
    } else {
      profile = new ProfileModel.blank();
    }
    return profile;
  }
}
