import 'package:sonr_app/style.dart';

/// Option Displayed in Checklist
class ChecklistOption {
  final String title;
  final RxBool isEnabled;
  ChecklistOption(this.title, this.isEnabled);

  void toggle() {
    isEnabled(!isEnabled.value);
  }
}

/// Form Field to Display List of Strings as Gradient Tab View
class Checklist extends StatelessWidget {
  final List<ChecklistOption> options;
  final Function(int idx) onSelectedOption;
  const Checklist({Key? key, required this.options, required this.onSelectedOption}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (currentIdx) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Color(0xffF8F8F9)),
            width: 180,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildOptions(),
            )),
        0.obs);
  }

  List<Widget> _buildOptions() {
    return List<Widget>.generate(
        options.length,
        (index) => GestureDetector(
              onTap: () => options[index].toggle(),
              child: Container(
                constraints: BoxConstraints(maxWidth: 160, minWidth: 40),
                height: 48,
                alignment: Alignment.center,
                child: options[index].title.light(color: options[index].isEnabled.value ? SonrColor.White : SonrColor.Black),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: options[index].isEnabled.value
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
                    color: options[index].isEnabled.value ? null : Colors.transparent),
              ),
            ));
  }
}
