import 'dart:io';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:metadata_fetch/metadata_fetch.dart' as MetaFetch;

const double S_CONTENT_HEIGHT_MODIFIER = 110;
const double E_CONTENT_WIDTH_MODIFIER = 20;

// ** Share from External App BottomSheet View ** //
class ShareSheet extends StatelessWidget {
  // Properties
  final Widget child;
  final Size size;
  final Payload payloadType;
  const ShareSheet({Key key, @required this.child, @required this.size, @required this.payloadType}) : super(key: key);

  // @ Bottom Sheet for Media
  factory ShareSheet.media(List<SharedMediaFile> sharedFiles) {
    // Get Sizing
    final Size window = Size(Get.width - 20, Get.height / 3 + 150);
    final Size content = Size(window.width - E_CONTENT_WIDTH_MODIFIER, window.height - S_CONTENT_HEIGHT_MODIFIER);

    // Build View
    return ShareSheet(
        child: _ShareSheetContentView(
          size: content,
          isUrl: false,
          child: _ShareItem(false, sharedFiles: sharedFiles, size: content),
        ),
        size: window,
        payloadType: Payload.MEDIA);
  }

  // @ Bottom Sheet for URL
  factory ShareSheet.url(String value) {
    // Get Sizing
    final Size window = Size(Get.width - 20, Get.height / 5 + 40);
    final Size content = Size(window.width - E_CONTENT_WIDTH_MODIFIER, window.height - S_CONTENT_HEIGHT_MODIFIER);

    // Build View
    return ShareSheet(
        child: _ShareSheetContentView(
          size: content,
          isUrl: true,
          child: _ShareItem(true, urlText: value, size: content),
        ),
        size: window,
        payloadType: Payload.URL);
  }

  // ^ Build Widget View ^ //
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        backendColor: Colors.transparent,
        child: Neumorphic(
            style: NeumorphicStyle(color: SonrColor.base),
            child: Container(
                width: size.width,
                height: size.height,
                padding: EdgeInsets.only(top: 6),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // @ Top Banner
                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // Bottom Left Close/Cancel Button
                    SonrButton.circle(onPressed: () => Get.back(), icon: SonrIcon.close),

                    SonrText.header("Share", size: 40),

                    // @ Top Right Confirm Button
                    SonrButton.circle(onPressed: () => Get.offNamed("/transfer"), icon: SonrIcon.accept),
                  ]),

                  // @ Window Content
                  Spacer(),
                  child,
                  Spacer()
                ]))));
  }
}

// ** ShareSheet Content Builder View ** //
class _ShareSheetContentView extends StatelessWidget {
  final Widget child;
  final bool isUrl;
  final Size size;
  const _ShareSheetContentView({Key key, @required this.child, @required this.size, @required this.isUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      child: Neumorphic(
          margin: EdgeInsets.only(top: 4, bottom: 4, left: 8),
          style: NeumorphicStyle(
            color: SonrColor.base,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
          ),
          child: isUrl ? _buildItemWithIcon() : _buildOnlyItem()),
    );
  }

  _buildOnlyItem() {
    return Neumorphic(
        style: NeumorphicStyle(
          depth: -8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        ),
        margin: EdgeInsets.all(10),
        child: child);
  }

  _buildItemWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // @ Sonr Icon
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: isUrl ? SonrIcon.url : SonrIcon.video,
        ),

        // @ Indent View
        Expanded(
          child: Neumorphic(
              style: NeumorphicStyle(
                depth: -8,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
              ),
              margin: EdgeInsets.all(10),
              child: child),
        ),
      ],
    );
  }
}

// ** ShareSheet Item Widget ** //
class _ShareItem extends StatefulWidget {
  final List<SharedMediaFile> sharedFiles;
  final Size size;
  final String urlText;
  final bool isURL;

  const _ShareItem(this.isURL, {@required this.size, this.sharedFiles, this.urlText, Key key}) : super(key: key);

  @override
  __ShareItemState createState() => __ShareItemState();
}

class __ShareItemState extends State<_ShareItem> {
  URLData urlData;
  bool urlDataLoaded = false;

  @override
  void initState() {
    fetchURLData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isURL) {
      // Set Payload
      SonrService.queueUrl(widget.urlText);
    }
    // Return Widget
    return Container(
        margin: EdgeInsets.all(8),
        child: urlDataLoaded
            ? widget.isURL
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SonrText.url(urlData),
                  )
                : _buildMediaView()
            : Container());
  }

  fetchURLData() async {
    var data = await MetaFetch.extract(widget.urlText);

    setState(() {
      urlData = URLData(data);
      urlDataLoaded = true;
    });
  }

  _buildMediaView() {
    // Get Shared File
    SharedMediaFile sharedIntent = widget.sharedFiles.length > 1 ? widget.sharedFiles.last : widget.sharedFiles.first;
    SonrService.queueMedia(sharedIntent.path);

    // Create View
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 1,
              minHeight: 1,
              maxHeight: widget.size.height - 20,
            ),
            child: Image.file(File(sharedIntent.path)),
          )),
    );
  }
}
