import 'package:sonr_app/style/style.dart';
import 'package:url_launcher/url_launcher.dart';

/// @ Widget for Expanded Media View
class URLCardItemView extends StatelessWidget {
  final TransferCard item;
  const URLCardItemView(this.item);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchURL(item.url!.url),
      child: Container(
        decoration: Neumorphic.floating(
          theme: Get.theme,
        ),
        child: Hero(
          tag: item.id,
          child: Container(
            height: 75,
            child: Container(),
          ),
        ),
      ),
    );
  }

  /// @ Launch a URL Event
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SonrSnack.error("Could not launch the URL.");
    }
  }
}
