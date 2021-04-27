import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:url_launcher/url_launcher.dart';

// ^ Widget for Expanded Media View
class URLCardItemView extends StatelessWidget {
  final TransferCardItem item;
  const URLCardItemView(this.item);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchURL(item.url.link),
      child: Container(
        decoration: Neumorph.floating(),
        child: Hero(
          tag: item.id,
          child: Container(
            height: 75,
            decoration: item.payload == Payload.MEDIA && item.metadata.mime.type == MIME_Type.image
                ? BoxDecoration(
                    image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
                    fit: BoxFit.cover,
                    image: MemoryImage(item.metadata.thumbnail),
                  ))
                : null,
            child: Container(),
          ),
        ),
      ),
    );
  }

  // ^ Launch a URL Event ^ //
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SonrSnack.error("Could not launch the URL.");
    }
  }
}
