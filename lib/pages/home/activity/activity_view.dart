import 'package:sonr_app/theme/theme.dart';
import '../home_controller.dart';

// ^ Activity View ^ //
class ActivityView extends GetView<HomeController> {
  ActivityView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: Neumorph.floating(),
      child: "Under Construction".h4,
    );
  }
}

class _ActivityListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
      ],
    );
  }
}
