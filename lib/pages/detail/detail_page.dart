import 'package:sonr_app/style/style.dart';
import 'detail.dart';
import 'views/views.dart';

class DetailPage extends StatelessWidget {
  /// Page Type
  final DetailPageType type;

  // * Constructer *
  const DetailPage({Key? key, required this.type}) : super(key: key);

  // Builds View By Page Type
  @override
  Widget build(BuildContext context) {
    if (type.isCards) {
      return CardsView.display(type);
    } else if (type.isDetail) {
      return DetailView.display(type);
    } else {
      return ErrorView.display(type);
    }
  }
}
