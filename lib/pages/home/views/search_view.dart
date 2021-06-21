import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';

class SearchResultsView extends GetView<HomeController> {
  SearchResultsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
          itemCount: controller.results.length,
          itemBuilder: (context, index) => SearchItem(
                item: controller.results[index],
              )),
    );
  }
}
