import 'package:sonr_app/pages/home/controllers/home_controller.dart';
import 'package:sonr_app/style/style.dart';

/// #### Card Search View - Displays Search View
class CardSearchField extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      height: 108,
      width: Width.ratio(0.4),
      alignment: Alignment.center,
      duration: 100.milliseconds,
      child: GestureDetector(
          onTap: () => controller.changeView(HomeView.Search),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BoxContainer(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  child: Stack(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Preferences.isDarkMode ? SimpleIcons.Search.whiteWith(size: 32) : SimpleIcons.Search.blackWith(size: 32),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: TextField(
                                  style: TextStyle(
                                    fontFamily: 'RFlex',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.ItemColor,
                                  ),
                                  showCursor: false,
                                  autofocus: false,
                                  onChanged: (val) {
                                    controller.query(val);
                                    controller.query.refresh();
                                  },
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Search...",
                                      hintStyle: TextStyle(
                                          fontFamily: 'RFlex',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                          color: Preferences.isDarkMode ? Colors.white38 : Colors.black38))),
                            ),
                          ),
                        ])),
                  ]))
            ],
          ))),
    );
  }
}

class SearchResultsView extends GetView<HomeController> {
  SearchResultsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlurredBackground(
      child: ListView.builder(
          itemCount: controller.results.length,
          itemBuilder: (context, index) => PostItem(
                controller.results[index],
              )),
    );
  }
}
