import 'package:flutter/material.dart';

class SonarCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 256,
      child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/contact");
          },
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Example Contact',
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
          )),
    );
  }
}
