import 'dart:io';

import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';

class Popup {
  // Build
  static Widget showImage(BuildContext context, NodeReceiveSuccess state) {
    return Dialog(
        shape: windowBorder(),
        insetAnimationDuration: Duration(seconds: 1),
        insetPadding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 125.0),
        elevation: 45,
        child: Container(
            decoration: windowDecoration(context),
            child: Column(
              children: [
                // Top Right Close/Cancel Button
                getCloseButton(context),

                // Some Space
                Padding(padding: EdgeInsets.all(15)),

                Expanded(
                  child: FittedBox(
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 1,
                            minHeight: 1,
                          ), // here
                          child: Image.file(File(state.metadata.path)))),
                ),

                FlatButton(
                  onPressed: () {
                    // Move to Page
                    context.getBloc(BlocType.File).add(GetFile(state.metadata));

                    // Pop View
                    Get.back();
                  },
                  child: Text("Go There"),
                )
              ],
            )));
  }
}
