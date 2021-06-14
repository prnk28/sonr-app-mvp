import 'package:sonr_app/style.dart';

typedef ActiveCallback = bool Function(int index);

class _GradientTab extends StatelessWidget {
  final ActiveCallback isActive;
  final String title;
  final int index;
  final Function(int idx) onSelected;

  const _GradientTab({Key? key, required this.isActive, required this.title, required this.index, required this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected(index),
      child: Container(
        constraints: BoxConstraints(maxWidth: 160, minWidth: 40),
        height: 48,
        alignment: Alignment.center,
        child: title.light(color: isActive(index) ? SonrColor.White : SonrColor.Black),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isActive(index) ? SonrTheme.primaryGradient : null,
            color: isActive(index) ? null : Colors.transparent),
      ),
    );
  }
}

/// Form Field to Display List of Strings as Gradient Tab View
class GradientTabsRow extends StatelessWidget {
  final List<String> tabs;
  final Function(int idx) onTabChanged;
  const GradientTabsRow({Key? key, required this.tabs, required this.onTabChanged}) : super(key: key);
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
              children: tabs
                  .map<Widget>((e) => _GradientTab(
                        title: e,
                        index: tabs.indexOf(e),
                        isActive: (index) => currentIdx.value == index,
                        onSelected: (int idx) {
                          currentIdx(idx);
                          onTabChanged(idx);
                        },
                      ))
                  .toList(),
            )),
        0.obs);
  }
}
