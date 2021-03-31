import 'package:sonr_app/theme/theme.dart';
import 'package:animated_widgets/animated_widgets.dart';

class FlatModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Handle Flat Mode Updates
    LobbyService.isFlatMode.listen((val) {
      if (!val) {
        Get.back();
      }
    });

    // Build View
    return Container(
        width: Get.width,
        height: Get.height,
        color: Colors.black87,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          ProfileCard(),
        ]));
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool animateOut = false;
  double _y = 20;

  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget(
      duration: 250.milliseconds,
      values: [
        Offset(0, _y), // disabled value value
        Offset(0, Get.height / 2), //intermediate value
        Offset(0, Get.height) //enabled value
      ],
      animationFinished: (val) {
        Get.find<LobbyService>().sendFlatMode();
        Get.back();
      },
      child: Draggable(
        child: _ProfileCardView(scale: 0.9),
        feedback: _ProfileCardView(scale: 0.9),
        childWhenDragging: Container(),
        axis: Axis.vertical,
        onDragUpdate: (details) {
          if (details.globalPosition.dy >= Get.height * 0.5) {
            HapticFeedback.heavyImpact();
          } else {
            setState(() {
              animateOut = true;
              _y = details.globalPosition.dy;
            });
            print("Animate out");
          }
        },
      ),
    );
  }
}

// ^ Profile Card View ^ //
class _ProfileCardView extends StatelessWidget {
  final double scale;
  _ProfileCardView({
    this.scale = 1.0,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420 * scale,
      width: (Get.width - 64) * scale,
      child: NeumorphicBackground(
        backendColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Neumorphic(
          style: SonrStyle.normal,
          margin: EdgeInsets.all(4),
          child: Container(
            height: 75,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(padding: EdgeInsets.all(4)),
              // Build Profile Pic
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Neumorphic(
                    padding: EdgeInsets.all(10),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: -10,
                    ),
                    child: UserService.current.contact.profilePicture),
              ),

              // Build Name
              UserService.current.contact.fullName,
              Divider(),
              Padding(padding: EdgeInsets.all(4)),

              // Quick Actions
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 78,
                  height: 78,
                  child: ShapeButton.circle(
                      depth: 4,
                      onPressed: () {},
                      text: SonrText.medium("Mobile", size: 12, color: Colors.black45),
                      icon: SonrIcon.gradient(Icons.phone, FlutterGradientNames.highFlight, size: 36),
                      iconPosition: WidgetPosition.Top),
                ),
                Padding(padding: EdgeInsets.all(6)),
                SizedBox(
                  width: 78,
                  height: 78,
                  child: ShapeButton.circle(
                      depth: 4,
                      onPressed: () {},
                      text: SonrText.medium("Text", size: 12, color: Colors.black45),
                      icon: SonrIcon.gradient(Icons.mail, FlutterGradientNames.teenParty, size: 36),
                      iconPosition: WidgetPosition.Top),
                ),
                Padding(padding: EdgeInsets.all(6)),
                SizedBox(
                    width: 78,
                    height: 78,
                    child: ShapeButton.circle(
                        depth: 4,
                        onPressed: () {},
                        text: SonrText.medium("Video", size: 12, color: Colors.black45),
                        icon: SonrIcon.gradient(Icons.video_call_rounded, FlutterGradientNames.deepBlue, size: 36),
                        iconPosition: WidgetPosition.Top)),
              ]),

              Divider(),
              Padding(padding: EdgeInsets.all(4)),

              // Brief Contact Card Info
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(UserService.current.contact.socials.length, (index) {
                    return UserService.current.contact.socials[index].provider.icon(IconType.Gradient, size: 35);
                  }))
            ]),
          ),
        ),
      ),
    );
  }
}
