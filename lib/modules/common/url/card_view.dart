import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Widget for Expanded Media View
class URLCardView extends StatelessWidget {
  final TransferCard card;
  const URLCardView(this.card);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.find<DeviceService>().launchURL(card.url.link),
      child: Neumorphic(
        style: SonrStyle.normal,
        margin: EdgeInsets.all(4),
        child: Hero(
          tag: card.id,
          child: Container(
            height: 75,
            decoration: card.payload == Payload.MEDIA && card.metadata.mime.type == MIME_Type.image
                ? BoxDecoration(
                    image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.luminosity),
                    fit: BoxFit.cover,
                    image: MemoryImage(card.metadata.thumbnail),
                  ))
                : null,
            child: Container(),
          ),
        ),
      ),
    );
  }
}
