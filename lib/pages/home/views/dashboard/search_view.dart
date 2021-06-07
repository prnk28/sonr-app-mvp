import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/pages/detail/items/contact/list_item.dart';
import 'package:sonr_app/style.dart';
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
            final item = controller.results[index];
            if (item.payload.isContact) {
              return ContactListItemView(item);
            } else if (item.payload.isUrl) {
              return PostFileItem(item: item);
            } else {
              return URLListItemView(item);
            }
          }),
    );
  }
}
