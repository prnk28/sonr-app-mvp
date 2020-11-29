import 'dart:io';

import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/controller/controller.dart';

class Popup {
  // Build
  static Widget showImage(BuildContext context) {
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
                getCloseButton(),

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
                          child: Image.file(
                              File(sonrStore.state.savedMetadata.path)))),
                ),

                FlatButton(
                  onPressed: () {
                    // Move to Page
                    context
                        .getBloc(BlocType.File)
                        .add(GetFile(sonrStore.state.savedMetadata));

                    // Pop View
                    RM.navigate.back();
                  },
                  child: Text("Go There"),
                )
              ],
            )));
  }
}
