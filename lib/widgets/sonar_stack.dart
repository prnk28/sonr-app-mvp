import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

class SonarStack extends StatelessWidget {
  Widget build(BuildContext context) {
    var repo = new FuturePreferencesRepository<ContactModel>(new ContactModelDesSer());
    var snapList = List<ContactModel>();
    repo.findAll().then((snap){
        snapList = snap;
    });
    return Stack(
      children: <Widget>[
        Swiper(
            layout: SwiperLayout.STACK,
            itemWidth: 325.0,
            itemHeight: 400.0,
            itemBuilder: (context, index) {
              for (var i = 0; i < snapList.length; i++) {
                return SonarCard(profile: snapList[i]);
              }
            },
            itemCount: snapList.length),
      ],
    );
  }
}
