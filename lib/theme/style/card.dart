import '../theme.dart';

class NeumorphCard extends StatelessWidget {
  final Widget child;
  final Rx<NeumorphCardParams> parameters;
  const NeumorphCard({Key key, @required this.child, @required this.parameters}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<NeumorphCardParams>>(
        (props) => AnimatedContainer(
              padding: EdgeInsets.all(8),
              decoration: Neumorphic.floating(),
              width: Width.reduced(props.value.widthReduction),
              height: Height.ratio(props.value.heightRatio),
              margin: props.value.margin ?? props.value.defaultMargin,
              duration: props.value.duration,
              child: AnimatedSlideSwitcher.fade(
                child: child,
                duration: props.value.fadeDuration,
              ),
            ),
        parameters);
  }
}

class NeumorphAvatarCard extends StatelessWidget {
  final Widget child;
  final Profile profile;
  const NeumorphAvatarCard({Key key, @required this.child, @required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final props = NeumorphCardParams.photoCard();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 42.0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: Neumorphic.compact(),
            width: Width.reduced(props.widthReduction),
            height: Height.ratio(props.heightRatio),
            margin: props.margin,
            child: AnimatedSlideSwitcher.fade(
              child: child,
              duration: props.fadeDuration,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
              decoration: Neumorphic.compact(shape: BoxShape.circle),
              padding: EdgeInsets.all(4),
              child: Container(
                width: 120,
                height: 120,
                child: profile.hasPicture()
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                      )
                    : SonrIcons.Avatar.greyWith(size: 120),
              )),
        )
      ],
    );
  }
}

class NeumorphCardParams {
  final double widthReduction;
  final double heightRatio;
  final EdgeInsets margin;
  final Duration fadeDuration;
  final Duration duration;
  final EdgeInsets defaultMargin = EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);

  NeumorphCardParams(
      {this.margin,
      this.duration = const Duration(milliseconds: 200),
      this.fadeDuration = const Duration(milliseconds: 2500),
      this.widthReduction = 0.15,
      this.heightRatio = 0.7});

  factory NeumorphCardParams.photoCard() {
    return NeumorphCardParams(heightRatio: 0.65, margin: EdgeInsets.only(bottom: Get.height * 0.2, left: Get.width * 0.05, right: Get.width * 0.05));
  }
}
