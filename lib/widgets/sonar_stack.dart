import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sonar_frontend/widgets/sonar_card.dart';

class SonarStack extends StatelessWidget {
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Swiper(
            layout: SwiperLayout.STACK,
            itemWidth: 350.0,
            itemHeight: 350.0,
            itemBuilder: (context, index) {
              return SonarCard();
            },
            itemCount: 10),
      ],
    );
  }
}
