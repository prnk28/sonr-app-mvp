part of 'home_screen.dart';

class FloaterButton extends StatefulWidget {
  const FloaterButton({Key key}) : super(key: key);

  @override
  _FloaterButtonState createState() => _FloaterButtonState();
}

class _FloaterButtonState extends State<FloaterButton>
    with SingleTickerProviderStateMixin {
  // Floating Button Animations
  Animation<double> _animation;
  AnimationController _animationController;
  final SonrService sonr = Get.find();

  @override
  void initState() {
    // ^ Setup Floater Animation ^ //
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Get Test File Path
            File file = await Get.find<HomeController>()
                .getAssetFileByPath("assets/images/test.jpg");

            // Queue File
            sonr.queue(Payload_Type.FILE, file: file);

            // Wait for Animation to Complete
            _animationController.reverse();
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
            // Get Test File Path
            File testFile = await Get.find<HomeController>()
                .getAssetFileByPath("assets/images/fat_test.jpg");

            // Queue File
            sonr.queue(Payload_Type.FILE, file: testFile);

            // Wait for Animation to Complete
            _animationController.reverse();
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
            // Queue File
            sonr.queue(Payload_Type.CONTACT);

            // Wait for Animation to Complete
            _animationController.reverse();
          },
        ),
      ],

      // animation controller
      animation: _animation,

      // On pressed change animation state
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.blue,

      // Flaoting Action button Icon
      iconData: Icons.star,
      backGroundColor: Colors.white,
    );
  }
}
