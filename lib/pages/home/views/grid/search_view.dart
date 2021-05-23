import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/style/style.dart';
import 'grid_controller.dart';

class SearchResultsView extends GetView<RecentsController> {
  SearchResultsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            return TransferItem(controller.results[index], type: TransferItemView.ListItem);
          }),
    );
  }
}
