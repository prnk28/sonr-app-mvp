import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/style/style.dart';
import 'dashboard_controller.dart';

class SearchResultsView extends GetView<DashboardController> {
  SearchResultsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            return TransferCardItem(controller.results[index], type: CardsViewType.ListItem);
          }),
    );
  }
}
