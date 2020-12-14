part of 'invite.dart';

class FileInviteView extends StatelessWidget {
  final Metadata metadata;
  final Peer from;

  const FileInviteView(this.metadata, this.from, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Preview Widget
    Widget preview;
    switch (metadata.mime.type) {
      case MIME_Type.audio:
        preview = Icon(Icons.audiotrack, size: 100);
        break;
      case MIME_Type.image:
        if (metadata.thumbnail != null) {
          preview = ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 1, minHeight: 1, maxWidth: 200), // here
                      child: Image.memory(metadata.thumbnail))));
        } else {
          preview = Icon(Icons.image, size: 100);
        }
        break;
      case MIME_Type.video:
        preview = Icon(Icons.video_collection, size: 100);
        break;
      case MIME_Type.text:
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
}
