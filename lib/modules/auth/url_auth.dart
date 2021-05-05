import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

// ^ URL Invite from AuthInvite Proftobuf ^ //
class URLAuthView extends StatelessWidget {
  final AuthInvite invite;
  URLAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Neumorph.floating(),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: Neumorph.floating(shape: BoxShape.circle),
              child: invite.from.profile.hasPicture()
                  ? Image.memory(Uint8List.fromList(invite.from.profile.picture))
                  : Icon(
                      Icons.insert_emoticon,
                      size: 60,
                      color: SonrColor.Black.withOpacity(0.5),
                    ),
            ),
          ),

          // From Information
          Column(mainAxisSize: MainAxisSize.min, children: [
            invite.from.profile.hasLastName()
                ? "${invite.from.profile.firstName} ${invite.from.profile.lastName}".gradient(gradient: FlutterGradientNames.solidStone)
                : "${invite.from.profile.firstName}".gradient(gradient: FlutterGradientNames.solidStone),
            Center(child: "Website Link".gradient(gradient: FlutterGradientNames.magicRay, size: 22)),
          ]),
        ]),
        Divider(),

        // @ URL Information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(child: _buildURLView(invite.url))),
          ],
        ),

        // @ Actions
        Divider(),
        Padding(padding: EdgeInsets.all(4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorButton.neutral(onPressed: () => SonrOverlay.back(), text: "Dismiss"),
            Padding(padding: EdgeInsets.all(8)),
            ColorButton.primary(
              onPressed: () => launchURL(invite.url.link),
              text: "Open",
              icon: SonrIcons.Discover,
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 14))
      ]),
    );
  }

  // ^ Method to Build View from Data ^ //
  Widget _buildURLView(URLLink data) {
    // Check open graph images
    if (data.images.length > 0) {
      return Column(children: [
        // @ Social Image
        Image.network(data.images.first.url),

        // @ URL Info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [data.title.h3, data.description.p],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Container(
              decoration: Neumorph.indented(),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SonrIcons.Link.gradient(),
                ),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: data.link.url,
                  ),
                )
              ])),
        )
      ]);
    }

    // Check twitter data
    if (data.hasTwitter()) {
      return Column(children: [
        // @ Social Image
        Image.network(data.twitter.image),

        // @ URL Info
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              data.title.h3,
              data.description.p,
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Container(
              decoration: Neumorph.indented(),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(padding: const EdgeInsets.only(left: 14.0, right: 8), child: SonrIcons.Link.gradient()),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: data.link.url,
                  ),
                )
              ])),
        )
      ]);
    }

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: data.link));
        SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
      },
      child: Container(
        decoration: Neumorph.indented(),
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: data.link.url,
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
