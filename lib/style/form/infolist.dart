import 'package:sonr_app/style/style.dart';

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
      color: AppTheme.itemColor,
      size: 24,
    );
  }

  /// Returns this Widgets Size
  Size get size => this.title.size(DisplayTextStyle.Light, fontSize: 24);

  /// Returns Text for Checklist Option based on State
  Widget text() {
    return title.light(color: AppTheme.itemColor, fontSize: 24);
  }
}

/// Form Field to Display List of Strings as Gradient Tab View
class Infolist extends StatelessWidget {
  final List<InfolistOption> options;
  const Infolist({Key? key, required this.options}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppTheme.backgroundColor,
            border: Border.all(
              color: AppTheme.foregroundColor,
              width: 1.5,
            )),
        constraints: options.boxConstraints,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () => options[index].onPressed(),
              child: Container(
                constraints: options.boxConstraints,
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
                          color: AppTheme.greyColor.withOpacity(0.25),
                          endIndent: 8,
                          indent: 8,
                        )
                      : Container(),
                ]),
              )),
          itemCount: options.length,
        ));
  }
}

extension InfolistOptionUtils on List<InfolistOption> {
  /// Return BoxConstraints based on List of InfolistOptions
  BoxConstraints get boxConstraints {
    // Initialize Width
    double maxTextWidth = 0;
    double maxIconWidth = this.length * 24;
    double adjustedPaddingWidth = this.length * 8;

    // Iterate Over Text
    this.forEach((o) {
      maxTextWidth += o.size.width;
    });

    return BoxConstraints(maxWidth: maxTextWidth + maxIconWidth + adjustedPaddingWidth);
  }
}
