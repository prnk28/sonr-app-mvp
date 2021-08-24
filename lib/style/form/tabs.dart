import 'package:sonr_app/style/style.dart';

/// Form Field to Display List of Strings as Gradient Tab View
class GradientTabs extends StatelessWidget {
  final List<String> tabs;
  final Function(int idx) onTabChanged;
  const GradientTabs({Key? key, required this.tabs, required this.onTabChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (currentIdx) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Get.isDarkMode ? AppTheme.ForegroundColor : Color(0xffF8F8F9)),
            height: 64,
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
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
                constraints: BoxConstraints(maxWidth: 150, minWidth: 40),
                height: 48,
                alignment: Alignment.center,
                child: AnimatedScale(
                    scale: currentIndex.value == index ? 1.1 : 1.0,
                    duration: 300.milliseconds,
                    child: tabs[index].light(
                      color: _buildTextColor(currentIndex.value == index),
                      align: TextAlign.center,
                    )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: currentIndex.value == index ? AppGradients.Primary() : null,
                    color: currentIndex.value == index ? null : Colors.transparent),
                duration: 150.milliseconds,
              ),
            ));
  }

  Color _buildTextColor(bool isCurrent) {
    if (isCurrent) {
      return AppColor.White;
    } else {
      return Get.isDarkMode ? AppTheme.GreyColor : AppColor.Black;
    }
  }
}
