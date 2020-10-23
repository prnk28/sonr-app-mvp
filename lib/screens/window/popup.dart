part of 'window.dart';

Widget buildImagePopupView(BuildContext context, NodeTransferSuccess state,
    void Function() onWindowTransferComplete) {
  // Callback
  if (onWindowTransferComplete != null) onWindowTransferComplete();

  // Build View
  return Column(
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
      Image.file(state.file.file)
    ],
  );
}
