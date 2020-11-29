part of 'elements.dart';

Widget getCloseButton({double top: 10, double right: 15}) {
  return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
          onTap: () {
            // Reload Files
            //context.getBloc(BlocType.File).add(GetAllFiles());

            // Pop Window
            Get.back();
          },
          child: Padding(
              padding: EdgeInsets.only(top: 10, right: 15),
              child: Icon(
                Icons.close_rounded,
                size: 35,
                color: Colors.grey[700],
              ))));
}

Widget getAppBarButton(
    BuildContext context, IconData icon, Function() onPressed) {
  return Stack(alignment: Alignment.center, children: [
    Align(
        alignment: Alignment.centerLeft,
        child: NeumorphicButton(
          padding: EdgeInsets.all(18),
          style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.convex,
              depth: 5),
          child: Icon(
            icon,
            color: Colors.black87,
          ),
          onPressed: onPressed,
        ))
  ]);
}
