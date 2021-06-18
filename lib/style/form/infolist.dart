import 'package:sonr_app/style.dart';

/// Option Displayed in Checklist
class InfolistOption {
  final String title;
  final IconData iconData;
  final Function onPressed;
  InfolistOption(
    this.title,
    this.iconData,
    this.onPressed,
  );

  /// Returns Icon for Checklist Option based on State
  Widget icon() {
    return iconData.icon(
      color: SonrTheme.itemColor,
      size: 24,
    );
  }

  /// Returns Text for Checklist Option based on State
  Widget text() {
    return title.light(color: SonrTheme.itemColor, fontSize: 24);
  }
}

/// Form Field to Display List of Strings as Gradient Tab View
class Infolist extends StatelessWidget {
  final List<InfolistOption> options;
  final Function(int idx) onSelectedOption;
  const Infolist({Key? key, required this.options, required this.onSelectedOption}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (currentIdx) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                border: Border.all(
                  color: SonrTheme.foregroundColor,
                  width: 1.5,
                )),
            width: 160,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildOptions(),
            )),
        0.obs);
  }

  List<Widget> _buildOptions() {
    return List<Widget>.generate(
        options.length,
        (index) => GestureDetector(
              onTap: () => options[index].onPressed(),
              child: Container(
                constraints: BoxConstraints(maxWidth: 160, minWidth: 40),
                child: Column(children: [
                  Padding(padding: EdgeWith.top(4)),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    options[index].icon(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: options[index].text(),
                    ),
                  ]),
                  index + 1 != options.length
                      ? Divider(
                          color: SonrTheme.greyColor.withOpacity(0.25),
                          endIndent: 8,
                          indent: 8,
                        )
                      : Container(),
                ]),
              ),
            ));
  }
}
