import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';
import 'package:url_launcher/url_launcher.dart';

/// @ Transfer Contact Item Details
class URLItemView extends StatelessWidget {
  final TransferCard item;
  const URLItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchURL(item.url!.url),
      child: BoxContainer(
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
      AppRoute.snack(SnackArgs.error("Could not launch the URL."));
    }
  }
}
