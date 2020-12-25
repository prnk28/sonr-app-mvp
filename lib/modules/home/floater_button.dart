import 'dart:io';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';

class FloaterButton extends HookWidget {
  const FloaterButton({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: Duration(seconds: 260));
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: controller);
    Animation<double> _animation =
        Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    return FloatingActionBubble(
      // Menu items
      items: <Bubble>[
        Bubble(
          title: "Photo",
          iconColor: Colors.white,
          bubbleColor: Colors.orange,
          icon: Icons.photo,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            Get.find<HomeController>().queueTest();
            controller.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: "Fat Photo",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.storage,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            Get.find<HomeController>().queueFatTest();
            controller.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: "Contact",
          iconColor: Colors.white,
          bubbleColor: Colors.brown[300],
          icon: Icons.person,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            Get.find<HomeController>().queueContact();
            controller.reverse();
          },
        ),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () =>
          controller.isCompleted ? controller.reverse() : controller.forward(),

      // Floating Action button Icon color
      iconColor: Colors.blue,

      // Flaoting Action button Icon
      iconData: Icons.star,
      backGroundColor: Colors.white,
    );
  }
}
