import 'dart:io';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

const double S_CONTENT_HEIGHT_MODIFIER = 110;
const double E_CONTENT_WIDTH_MODIFIER = 20;

/// #### Share from External App BottomSheet View
class ShareSheet extends StatelessWidget {
  // Properties
  final Widget child;
  final Size size;
  final Payload payload;
  final SFile? mediaFile;
  final URLLink? url;
  const ShareSheet({
    Key? key,
    required this.child,
    required this.size,
    required this.payload,
    this.mediaFile,
    this.url,
  }) : super(key: key);

  // @ Bottom Sheet for Media
  factory ShareSheet.media(List<SharedMediaFile> sharedFiles) {
    // Get Sizing
    final Size window = Size(Get.width - 20, Get.height / 3 + 150);
    final Size content = Size(window.width - E_CONTENT_WIDTH_MODIFIER, window.height - S_CONTENT_HEIGHT_MODIFIER);

    // Build View
    return ShareSheet(
      child: _ShareItemMedia(sharedFiles: sharedFiles, size: content),
      size: window,
      payload: Payload.MEDIA,
      mediaFile: sharedFiles.toSFile(),
    );
  }

  // @ Bottom Sheet for URL
  factory ShareSheet.url(URLLink? value) {
    // Get Sizing
    final Size window = Size(Get.width - 20, Get.height / 5 + 40);
    final Size content = Size(window.width - E_CONTENT_WIDTH_MODIFIER, window.height - S_CONTENT_HEIGHT_MODIFIER);

    // Build View
    return ShareSheet(child: _ShareItemURL(url: value, size: content), size: window, payload: Payload.URL, url: value);
  }
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // @ Top Banner
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Bottom Left Close/Cancel Button
            ActionButton(onPressed: () => Get.back(), iconData: SimpleIcons.Close),

            "Share".heading(),

            // @ Top Right Confirm Button
            ActionButton(
                onPressed: () {
                  // if (payload == Payload.URL) {
                  //   TransferService.setUrl(url!.url);
                  // } else {
                  //   TransferService.setMedia(mediaFile!);
                  // }
                },
                iconData: SimpleIcons.Check),
          ]),

          // @ Window Content
          Spacer(),
          BoxContainer(
            width: size.width,
            height: size.height,
            child: Container(margin: EdgeInsets.only(top: 4, bottom: 4, left: 8), child: child),
          ),
          Spacer()
        ]));
  }
}

/// #### Share Item Media View
class _ShareItemMedia extends StatelessWidget {
  final List<SharedMediaFile>? sharedFiles;
  final Size? size;

  const _ShareItemMedia({Key? key, this.sharedFiles, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Get Shared File
    SharedMediaFile sharedIntent = sharedFiles!.length > 1 ? sharedFiles!.last : sharedFiles!.first;
    return BoxContainer(
        margin: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 1,
                  minHeight: 1,
                  maxHeight: size!.height - 20,
                ),
                child: Image.file(File(sharedIntent.path)),
              )),
        ));
  }
}

/// #### Share Item URL View
class _ShareItemURL extends StatelessWidget {
  final URLLink? url;
  final Size? size;
  const _ShareItemURL({Key? key, this.url, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // @ Sonr Icon
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SimpleIcons.Link.white,
        ),

        // @ Indent View
        Expanded(
          child: BoxContainer(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildURLView(url!),
              )),
        ),
      ],
    );
  }

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
            children: [
              data.title.subheading(),
              data.description.paragraph(),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: data.url));
            AppRoute.snack(SnackArgs.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
          },
          child: BoxContainer(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SimpleIcons.Link.white,
                ),

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
              data.title.subheading(),
              data.description.paragraph(),
            ],
          ),
        ),

        // @ Link Preview
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: data.url));
            AppRoute.snack(SnackArgs.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
          },
          child: BoxContainer(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                // URL Icon
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 8),
                  child: SimpleIcons.Link.white,
                ),

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

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: data.url));
        AppRoute.snack(SnackArgs.alert(title: "Copied!", message: "URL copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
      },
      child: BoxContainer(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: data.url.url,
        ),
      ),
    );
  }
}
