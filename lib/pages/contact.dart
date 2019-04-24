import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key key}) : super(key: key);
  static const routeName = '/contact';

  @override
  Widget build(BuildContext context) {
    final ContactModel args = ModalRoute.of(context).settings.arguments;
    // 4BBEE3 Zima Blue
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
                _addContactToDevice(args);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[SonarCard(profile: args)],
        ));
  }

  _addContactToDevice(ContactModel item) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission == PermissionStatus.granted) {
      var newContact = item.toContact();
      await ContactsService.addContact(newContact);
    } else {
      await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
    }
  }
}
