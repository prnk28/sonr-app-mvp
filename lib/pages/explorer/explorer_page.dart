import 'views/nearby_list.dart';
import 'package:sonr_app/style.dart';
import 'explorer_controller.dart';
import 'views/access_view.dart';

class ExplorerPage extends GetView<ExplorerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: "Welcome".heading()),
      backgroundColor: SonrTheme.backgroundColor,
      body: Center(
        child: Container(
          width: 1280,
          height: 800,
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(24),
              width: 1280 / 3 * 2,
              child: AccessView(),
            ),
            Container(
              padding: EdgeInsets.all(24),
              width: 1280 / 3,
              child: NearbyListView(),
            ),
          ]),
        ),
      ),
    );
  }
}
