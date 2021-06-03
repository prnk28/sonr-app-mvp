import 'package:sonr_app/style/style.dart';
import 'detail.dart';
import 'views/views.dart';

class DetailPage extends StatelessWidget {
  /// Page Type
  final DetailPageType type;
  final TransferItemsType? itemsType;

  // * Constructer *
  const DetailPage({Key? key, required this.type, this.itemsType}) : super(key: key);

  // Builds View By Page Type
  @override
  Widget build(BuildContext context) {
    if (type.isCards) {
      return CardsView.display(type, itemsType!);
    } else if (type.isDetail) {
      return DetailView.display(type);
    } else {
      return ErrorView.display(type);
    }
  }
}
