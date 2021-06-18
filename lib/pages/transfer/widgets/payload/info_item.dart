import 'package:sonr_app/style.dart';

class PayloadItemInfo extends StatelessWidget {
  final SonrFile_Item item;

  const PayloadItemInfo({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: item.prettyName().subheading(color: SonrTheme.itemColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: item.prettySize().light(color: SonrTheme.itemColor),
          )
        ],
      ),
    );
  }
}
