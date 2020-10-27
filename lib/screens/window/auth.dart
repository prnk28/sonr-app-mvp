part of 'window.dart';

Widget buildAuthenticationView(BuildContext context, NodeRequestInitial state) {
  return Column(
    children: [
      // Top Right Close/Cancel Button
      getCloseButton(context),

      // Build Item from Metadata and Peer
      _buildItem(context, state),
      Padding(padding: EdgeInsets.only(top: 25)),

      // Build Auth Action
      _buildAuthButton(context, state)
    ],
  );
}

Row _buildItem(BuildContext context, NodeRequestInitial state) {
  // Get Data
  var from = state.from;
  var metadata = state.metadata;

  // Preview Widget
  Widget preview;
  switch (state.metadata.type) {
    case FileType.Audio:
      preview = Icon(Icons.audiotrack, size: 100);
      break;
    case FileType.Image:
      if (metadata.thumbnail != null) {
        preview = Image.memory(metadata.thumbnail);
      } else {
        preview = Icon(Icons.image, size: 100);
      }
      break;
    case FileType.Unknown:
      preview = Icon(Icons.device_unknown, size: 100);
      break;
    case FileType.Video:
      preview = Icon(Icons.video_collection, size: 100);
      break;
    case FileType.Word:
      preview = Icon(Icons.sort_by_alpha, size: 100);
      break;
    default:
      preview = Icon(Icons.storage, size: 100);
      break;
  }

  // Build View
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    preview,
    Padding(padding: EdgeInsets.all(8)),
    Column(
      children: [
        Text(from.profile.firstName, style: headerTextStyle()),
        Text(from.device,
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
    BuildContext context, NodeRequestInitial state) {
  // Build View
  return NeumorphicButton(
      onPressed: () {
        // Update WebBloc to Inform User Accepted
        context
            .getBloc(BlocType.User)
            .add(NodeAccepted(state.from, state.offer, state.metadata));

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
