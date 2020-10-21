part of 'window.dart';

Widget buildAuthenticationView(BuildContext context, Requested state) {
  return Column(
    children: [
      // Top Right Close/Cancel Button
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                // Update WebBloc to Inform User Declined
                context
                    .getBloc(BlocType.Web)
                    .add(Authorize(false, state.from, false, null));

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

      // Build Item from Metadata and Peer
      _buildItem(context, state.from),
      Padding(padding: EdgeInsets.only(top: 25)),

      // Build Auth Action
      _buildAuthButton(context, state.from, state.offer, state.metadata)
    ],
  );
}

Row _buildItem(BuildContext context, Peer match) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.image, size: 100),
    Column(
      children: [
        Text(match.profile.firstName, style: headerTextStyle()),
        Text(match.device,
            style: TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.black54))
      ],
    ),
  ]); // FlatButton// Container
}

NeumorphicButton _buildAuthButton(
    BuildContext context, Peer match, dynamic offer, Metadata metadata) {
  return NeumorphicButton(
      onPressed: () {
// Update WebBloc to Inform User Accepted
        context
            .getBloc(BlocType.Web)
            .add(Authorize(true, match, offer, metadata));
      },
      style: NeumorphicStyle(
          depth: 8,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: Text("Accept", style: smallTextStyle())); // FlatButton// Container
}
