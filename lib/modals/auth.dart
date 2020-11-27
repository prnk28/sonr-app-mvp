part of 'window.dart';

Widget buildAuthenticationView(BuildContext context, AuthMessage message) {
  return Column(
    children: [
      // Top Right Close/Cancel Button
      getCloseButton(context),

      // Build Item from Metadata and Peer
      _buildItem(context, message),
      Padding(padding: EdgeInsets.only(top: 8)),

      // Build Auth Action
      _buildAuthButton(context, message)
    ],
  );
}

Row _buildItem(BuildContext context, AuthMessage state) {
  // Get Data
  var from = state.from;
  var metadata = state.metadata;

  // Preview Widget
  Widget preview;
  switch (state.metadata.mime.type) {
    case "audio":
      preview = Icon(Icons.audiotrack, size: 100);
      break;
    case "image":
      if (metadata.thumbnail != null) {
        preview = ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minWidth: 1, minHeight: 1), // here
                    child: Image.memory(metadata.thumbnail))));
      } else {
        preview = Icon(Icons.image, size: 100);
      }
      break;
    case "video":
      preview = Icon(Icons.video_collection, size: 100);
      break;
    case "text":
      preview = Icon(Icons.sort_by_alpha, size: 100);
      break;
    default:
      preview = Icon(Icons.device_unknown, size: 100);
      break;
  }

  // Build View
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    preview,
    Padding(padding: EdgeInsets.all(8)),
    Column(
      children: [
        Text(from.firstName, style: headerTextStyle()),
        Text(from.device.platform,
            style: TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.black54))
      ],
    ),
  ]); // FlatButton// Container
}

NeumorphicButton _buildAuthButton(BuildContext context, AuthMessage state) {
  // Build View
  return NeumorphicButton(
      onPressed: () {
        // Update WebBloc to Inform User Accepted
        context
            .getBloc(BlocType.Sonr)
            .add(NodeRespondPeer(true, state.from, state.metadata));

        // Pop Window
        Navigator.pop(context);
      },
      style: NeumorphicStyle(
          depth: 8,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: Text("Accept", style: smallTextStyle())); // FlatButton// Container
}
