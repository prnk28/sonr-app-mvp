import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

//// @ TransferView: Builds View based on TransferItem Payload Type
class SearchItem extends StatelessWidget {
  /// TransferItem: SQL Reference to Protobuf
  final TransferCard item;
  const SearchItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // @ Build Contact Card by Size
    if (item.payload == Payload.CONTACT) {
      return ContactItemView(item: item);
    }

    // @ Build URL Card by Size
    else if (item.payload == Payload.URL) {
      return URLItemView(item: item);
    }

    // @ Build Media/File Card by Size
    else {
      return FileItemView(item: item);
    }
  }
}
