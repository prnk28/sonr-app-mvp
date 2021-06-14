import 'package:sonr_app/style.dart';

class _ChecklistOption extends StatelessWidget {
  final ActiveCallback isActive;
  final String title;
  final int index;
  final Function(int idx) onSelected;

  const _ChecklistOption({Key? key, required this.isActive, required this.title, required this.index, required this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 140, minWidth: 40),
      height: 38,
      alignment: Alignment.center,
      child: title.light(color: isActive(index) ? SonrColor.White : SonrColor.Black),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isActive(index) ? SonrTheme.primaryGradient : null,
          color: isActive(index) ? null : Colors.transparent),
    );
  }
}

/// Form Field to Display List of Strings as Gradient Tab View
class ChecklistColumn extends StatelessWidget {
  final List<String> options;
  final Function(int idx) onSelectedOption;
  const ChecklistColumn({Key? key, required this.options, required this.onSelectedOption}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (currentIdx) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Color(0xffF8F8F9)),
            width: 180,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options
                  .map<Widget>((e) => _ChecklistOption(
                        title: e,
                        index: options.indexOf(e),
                        isActive: (index) => currentIdx.value == index,
                        onSelected: (int idx) {
                          currentIdx(idx);
                          onSelectedOption(idx);
                        },
                      ))
                  .toList(),
            )),
        0.obs);
  }
}
