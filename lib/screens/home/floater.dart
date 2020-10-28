part of 'home.dart';

class FloaterButton extends StatelessWidget {
  final Animation<double> animation;
  final AnimationController animationController;
  final Function(String) onAnimationComplete;

  const FloaterButton(
      this.animation, this.animationController, this.onAnimationComplete,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
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
            // Get Photo
            final pickedFile =
                await picker.getImage(source: ImageSource.camera);

            // Queue File
            context.getBloc(BlocType.Data).add(UserQueuedFile(
                TrafficDirection.Outgoing,
                rawFile: File(pickedFile.path)));

            // Wait for Animation to Complete
            animationController.reverse();

            // Send Callback
            if (onAnimationComplete != null) {
              onAnimationComplete("File");
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
          onPress: () {
            // Queue File
            context
                .getBloc(BlocType.Data)
                .add(UserQueuedFile(TrafficDirection.Outgoing));

            // Wait for Animation to Complete
            animationController.reverse();

            // Send Callback
            if (onAnimationComplete != null) {
              onAnimationComplete("File");
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
            animationController.reverse();

            // Send Callback
            if (onAnimationComplete != null) {
              onAnimationComplete("Contact");
            }
          },
        ),
      ],

      // animation controller
      animation: animation,

      // On pressed change animation state
      onPress: () => animationController.isCompleted
          ? animationController.reverse()
          : animationController.forward(),

      // Floating Action button Icon color
      iconColor: Colors.blue,

      // Flaoting Action button Icon
      iconData: Icons.star,
      backGroundColor: Colors.white,
    );
  }
}
