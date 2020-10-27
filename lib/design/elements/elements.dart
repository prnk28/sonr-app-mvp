import 'dart:ui';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:sonar_app/core/core.dart';

// Design Elements
part 'appbar.dart';
part 'button.dart';
part 'painter.dart';
part 'textStyle.dart';
part 'textField.dart';

// ** Constant For Show Modal ** //
RoundedRectangleBorder windowBorder() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0));
}

BoxDecoration windowDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: NeumorphicTheme.baseColor(context),
  );
}

AlertDialog detailDeleteDialog({Function() onCancel, Function() onDelete}) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
    onPressed: () {
      onCancel();
    },
  );
  Widget deleteButton = FlatButton(
    child: Text("Delete", style: TextStyle(color: Colors.red)),
    onPressed: () {
      onDelete();
    },
  );

  // Create Window
  return AlertDialog(
    titlePadding: EdgeInsets.only(left: 35, top: 20),
    contentPadding: EdgeInsets.only(left: 35, top: 20, right: 24, bottom: 24),
    actionsPadding: EdgeInsets.only(right: 25),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    title: Text("Trash?", style: TextStyle(color: Colors.black)),
    content: Text("Are you sure you want to delete this file?",
        style: TextStyle(color: Colors.grey[700])),
    actions: [
      cancelButton,
      deleteButton,
    ],
  );
}

showRedToast(FToast fToast, String message, IconData icon) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(
          width: 12.0,
        ),
        Text(message, style: TextStyle(color: Colors.white)),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 1, milliseconds: 500),
  );
}

showGreenToast(FToast fToast, String message, IconData icon) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0), color: Colors.greenAccent),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(
          width: 12.0,
        ),
        Text(message, style: TextStyle(color: Colors.white)),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 1, milliseconds: 500),
  );
}
