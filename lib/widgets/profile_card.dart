import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
    Widget build(BuildContext context) {
    return SizedBox(
    height: 256,
    width: 350,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text('John Smith',
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Name'),
            leading: Icon(
              Icons.person,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('(408) 555-1212',
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Phone'),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('costa@example.com'),
            subtitle: Text('E-Mail'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
      //elevation: 6,
    ));
  }
}
