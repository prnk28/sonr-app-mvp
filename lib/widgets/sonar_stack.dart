import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/model/contact_model.dart';
import 'package:sonar_frontend/utils/card_util.dart';
import 'package:sonar_frontend/widgets/dynamic_card.dart';

class SonarStack extends StatefulWidget {
  const SonarStack({Key key}) : super(key: key);

  // Create Widget State
  @override
  _SonarStackState createState() => _SonarStackState();
}

class _SonarStackState extends State<SonarStack> {
  // Storage Data
  final LocalStorage storage = new LocalStorage('sonar_app');
  bool initialized = false;
  ContactList list;

  // Page Management
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // Build the Widget
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Load Data into List
          if (!initialized) {
            list = CardUtility.getContactModelList(storage);
            initialized = true;
          }

          // Return Widget by Count
          if (list.items.length == 0) {
            return Center(
                child: Container(
              child: Center(
                  child: Text("Currently No Cards.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 26))),
              width: 325,
              height: 400,
            ));
          } else if (list.items.length == 1) {
            return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5725,
                  child: DynamCard(profile: list.items[0], offset: pageOffset, headerPath: "assets/images/headers/1.jpg",),
            ));
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5725,
              child: PageView(
                  controller: pageController,
                  children: CardUtility.createCardWidgets(list, pageOffset)),
            );
          }
        });
  }
}
