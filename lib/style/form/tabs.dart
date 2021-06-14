import 'package:sonr_app/style.dart';

/// Form Field to Display List of Strings as Gradient Tab View
class GradientTabs extends StatelessWidget {
  final List<String> tabs;
  final Function(int idx) onTabChanged;
  const GradientTabs({Key? key, required this.tabs, required this.onTabChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (currentIdx) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Color(0xffF8F8F9)),
            height: 64,
            width: Width.full,
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildTabs(currentIdx),
            )),
        0.obs);
  }

  // @ Helper: Method to Build Tab Options
  List<Widget> _buildTabs(RxInt currentIndex) {
    return List<Widget>.generate(
        tabs.length,
        (index) => GestureDetector(
              onTap: () {
                currentIndex(index);
                onTabChanged(index);
              },
              child: AnimatedContainer(
                constraints: BoxConstraints(maxWidth: 160, minWidth: 40),
                height: 48,
                alignment: Alignment.center,
                child: AnimatedScale(
                    scale: currentIndex.value == index ? 1.1 : 1.0,
                    child: tabs[index].light(color: currentIndex.value == index ? SonrColor.White : SonrColor.Black)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: currentIndex.value == index
                        ? RadialGradient(
                            colors: [
                              Color(0xffFFCF14),
                              Color(0xffF3ACFF),
                              Color(0xff8AECFF),
                            ],
                            stops: [0, 0.45, 1],
                            center: Alignment.center,
                            focal: Alignment.topRight,
                            tileMode: TileMode.clamp,
                            radius: 2,
                          )
                        : null,
                    color: currentIndex.value == index ? null : Colors.transparent),
                duration: 150.milliseconds,
              ),
            ));
  }
}