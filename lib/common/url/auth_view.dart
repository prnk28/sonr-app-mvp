import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ URL Invite from AuthInvite Proftobuf ^ //
class URLAuthView extends StatelessWidget {
  final AuthInvite invite;
  URLAuthView(this.invite);

  @override
  Widget build(BuildContext context) {
    final card = invite.card;
    return Neumorphic(
      style: SonrStyle.normal,
      margin: EdgeInsets.all(8),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        // @ Header
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Build Profile Pic
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
            child: Neumorphic(
              padding: EdgeInsets.all(4),
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                depth: -10,
              ),
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
                ? SonrText.gradient(invite.from.profile.firstName + " " + invite.from.profile.lastName, FlutterGradientNames.premiumDark, size: 32)
                : SonrText.gradient(invite.from.profile.firstName, FlutterGradientNames.premiumDark, size: 32),
            Center(child: SonrText.gradient("Website Link", FlutterGradientNames.magicRay, size: 22)),
          ]),
        ]),
        Divider(),

        // @ URL Information
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(child: _buildURLView(card))),
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
              onPressed: () => Get.find<DeviceService>().launchURL(card.url.link),
              text: "Open",
              icon: SonrIcon.gradient(Icons.open_in_browser_rounded, FlutterGradientNames.aquaGuidance, size: 28),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 14))
      ]),
    );
  }

  // ^ Method to Build View from Data ^ //
  Widget _buildURLView(TransferCard card) {
    final data = card.url;
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
            children: [
              SonrText.header(data.title, size: 22),
              SonrText.normal(data.description, size: 16),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Neumorphic(
              style: SonrStyle.indented,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SonrIcon.url,
                ),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(card.url.link),
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
              SonrText.header(data.title, size: 22),
              SonrText.normal(data.description, size: 16),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(new ClipboardData(text: data.link));
            SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
          },
          child: Neumorphic(
              style: SonrStyle.indented,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SonrIcon.url,
                ),

                // Link Preview
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(card.url.link),
                  ),
                )
              ])),
        )
      ]);
    }

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(new ClipboardData(text: data.link));
        SonrSnack.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
      },
      child: Neumorphic(
        style: SonrStyle.indented,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SonrText.url(card.url.link),
        ),
      ),
    );
  }
}
