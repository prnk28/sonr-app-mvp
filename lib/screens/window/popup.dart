import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';

class Popup {
  static Widget showImage(BuildContext context, NodeTransferSuccess state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: screenSize.height * 0.6,
        width: screenSize.width * 0.6,
        child: Column(
          children: [
            // Top Right Close/Cancel Button
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      // Pop Window
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Icon(
                          Icons.close_rounded,
                          size: 35,
                          color: Colors.grey[700],
                        )))),
            // Some Space
            Padding(padding: EdgeInsets.all(15)),

            Image.file(state.file.raw)
          ],
        ));
  }
}
