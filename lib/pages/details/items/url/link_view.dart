import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLinkView extends StatelessWidget {
  /// URLLink Data
  final URLLink data;

  /// Enable lanching website `onTap`
  final bool enableLaunch;

  /// Enable copying to clipboard `onLongPress`
  final bool enableCopy;

  /// Fetches URLLink Data from String and Creates URLLinkView
  static Future<URLLinkView> fromString(String url, {bool enableLaunch = false, bool enableCopy = true}) async {
    URLLink data = await SonrService.getURL(url);
    return URLLinkView(data: data, enableCopy: enableCopy, enableLaunch: enableLaunch);
  }

  const URLLinkView({Key? key, required this.data, this.enableLaunch = false, this.enableCopy = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Social Image
      _URLLinkImage(data: data),

      // URL Info
      _URLLinkInfo(data: data),

      //  Link Preview
      GestureDetector(
        onTap: _launchURL,
        onLongPress: _copyURL,
        child: Container(
            decoration: Neumorphic.indented(
              theme: Get.theme,
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              // URL Icon
              Padding(padding: const EdgeInsets.only(left: 14.0, right: 8), child: SonrIcons.Link.gradient()),

              // Link Preview
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: data.url.url,
                ),
              )
            ])),
      )
    ]);
  }

  /// Launch URL from URLLink
  void _copyURL() async {
    if (enableCopy && data.url.isURL) {
      Clipboard.setData(ClipboardData(text: data.url));
      AppRoute.snack(SnackArgs.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
    }
  }

  /// Launch URL from URLLink
  Future<void> _launchURL() async {
    if (enableLaunch && data.url.isURL) {
      if (await canLaunch(data.url)) {
        await launch(data.url);
      } else {
        AppRoute.snack(SnackArgs.error("Could not launch the URL."));
      }
    }
  }
}

/// @ Builds Image from URLLink Data
class _URLLinkImage extends StatelessWidget {
  final URLLink data;
  const _URLLinkImage({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (data.images.length > 0) {
      return Image.network(data.images.first.url);
    } else {
      if (data.hasTwitter()) {
        return Image.network(data.twitter.image);
      }
      return Container();
    }
  }
}

/// @ Builds Info from URLLink Data
class _URLLinkInfo extends StatelessWidget {
  final URLLink data;
  const _URLLinkInfo({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (data.hasTitle()) {
      // @ URL Info
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            data.title.subheading(),
            data.description.paragraph(),
          ],
        ),
      );
    }
    return Container();
  }
}
