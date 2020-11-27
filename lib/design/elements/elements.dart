import 'dart:math';
import 'dart:ui';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonar_app/screens/screens.dart';

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

AlertDialog detailFailureDialog({Function() onCancel, Function() onDelete}) {
  Widget discardButton = FlatButton(
    child: Text("Continue", style: TextStyle(color: Colors.red)),
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
    title: Text("File not found", style: TextStyle(color: Colors.black)),
    content: Text("Discard file and return Home",
        style: TextStyle(color: Colors.grey[700])),
    actions: [
      discardButton,
    ],
  );
}

IconData iconDataFromKind(String kind) {
  switch (kind) {
    case "audio":
      return Icons.audiotrack;
      break;
    case "image":
      return Icons.image;
      break;
    case "video":
      return Icons.video_collection;
      break;
    case "text":
      return Icons.sort_by_alpha;
      break;
    default:
      return Icons.device_unknown;
      break;
  }
}
