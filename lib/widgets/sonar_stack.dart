import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

class SonarStack extends StatefulWidget {
  const SonarStack({Key key}) : super(key: key);

  // Create Widget State
  @override
  _SonarStackState createState() => _SonarStackState();
}

class _SonarStackState extends State<SonarStack> {
  // Storage Data
  final ContactList list = new ContactList();
  final LocalStorage storage = new LocalStorage('sonar_app');
  bool initialized = false;

  // Build the Widget
  @override
  Widget build(BuildContext context) {
    // Return FutureBuilder for DataBased Reading
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!initialized) {
            var items = storage.getItem('contact_items');

            if (items != null) {
              (items as List).forEach((item) {
                final todoItem = new ContactModel(
                    name: item['name'],
                    phone: item['phone'],
                    email: item['email'],
                    facebook: item['facebook'],
                    twitter: item['twitter'],
                    snapchat: item['snapchat'],
                    instagram: item['instagram']);
                list.items.add(todoItem);
              });
            }

            initialized = true;
          }

          // Return Stack
          return Stack(
            children: <Widget>[
              Swiper(
                  layout: SwiperLayout.STACK,
                  itemWidth: 325.0,
                  itemHeight: 400.0,
                  itemBuilder: (context, index) {
                    if (list.items.length > 0) {
                      for (var i = 0; i < list.items.length; i++) {
                        return SonarCard(profile: list.items[i]);
                      }
                    }
                  },
                  itemCount: list.items.length),
            ],
          );
        });
  }
}
