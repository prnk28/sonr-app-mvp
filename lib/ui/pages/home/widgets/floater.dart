part of '../home.dart';

enum DataType {
  File,
  Link,
  Contact,
}

class FloaterButton extends StatefulWidget {
  final Function(DataType) onAnimationComplete;

  const FloaterButton(this.onAnimationComplete, {Key key}) : super(key: key);

  @override
  _FloaterButtonState createState() => _FloaterButtonState();
}

class _FloaterButtonState extends State<FloaterButton>
    with SingleTickerProviderStateMixin {
  // Floating Button Animations
  Animation<double> _animation;
  AnimationController _animationController;

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
    final TransferController transferController = Get.put(TransferController());
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
            File file = await getAssetFileByPath("assets/images/test.jpg");

            // Queue File
            transferController.queueFile(file);

            // Wait for Animation to Complete
            _animationController.reverse();

            // Send Callback
            if (widget.onAnimationComplete != null) {
              widget.onAnimationComplete(DataType.File);
            }
          },
        ),
        // Floating action menu item
        Bubble(
          title: "File (Fat Test)",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.storage,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            // Get Test File Path
            File testFile =
                await getAssetFileByPath("assets/images/fat_test.jpg");

            // Queue File
            transferController.queueFile(testFile);

            // Wait for Animation to Complete
            _animationController.reverse();

            // Send Callback
            if (widget.onAnimationComplete != null) {
              widget.onAnimationComplete(DataType.File);
            }
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
            // Wait for Animation to Complete
            _animationController.reverse();

            // Send Callback
            if (widget.onAnimationComplete != null) {
              widget.onAnimationComplete(DataType.Contact);
            }
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

Future<File> getAssetFileByPath(String path) async {
  // Get Application Directory
  Directory directory = await getApplicationDocumentsDirectory();

  // Get File Extension and Set Temp DB Extenstion
  var dbPath = join(directory.path, basename(path));

  // Get Byte Data
  ByteData data = await rootBundle.load(path);

  // Get Bytes as Int
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  // Return File Object
  return await File(dbPath).writeAsBytes(bytes);
}
