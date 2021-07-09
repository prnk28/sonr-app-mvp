import 'package:sonr_app/style/style.dart';

/// Option Displayed in Checklist
class InfolistOption {
  final String title;
  final IconData iconData;
  final Function? onPressed;
  final bool isHeader;
  final Color? iconColor;
  final Color? textColor;

  InfolistOption(
    this.title,
    this.iconData, {
    this.onPressed,
    this.iconColor,
    this.textColor,
    this.isHeader = false,
  });

  /// Returns Icon for Checklist Option based on State
  Widget icon() {
    return iconData.icon(
      color: iconColor ?? AppTheme.ItemColor,
      size: 32,
    );
  }

  /// Returns this Widgets Size
  Size get size => this.title.size(
        isHeader ? DisplayTextStyle.Subheading : DisplayTextStyle.Light,
        fontSize: isHeader ? 26 : 24,
      );

  /// Returns Text for Checklist Option based on State
  Widget text() {
    if (isHeader) {
      return title.subheading(
        color: textColor ?? AppTheme.ItemColor,
        fontSize: 26,
        align: TextAlign.center,
      );
    }
    return title.light(color: textColor ?? AppTheme.ItemColor, fontSize: 24);
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
            color: AppTheme.BackgroundColor,
            border: Border.all(
              color: AppTheme.ForegroundColor,
              width: 1.5,
            )),
        constraints: options.boxConstraints,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                if (options[index].onPressed != null) {
                  options[index].onPressed!();
                }
              },
              child: Container(
                constraints: options.boxConstraints,
                child: Column(children: [
                  Padding(padding: EdgeWith.top(4)),
                  Row(
                    mainAxisAlignment: options[index].isHeader ? MainAxisAlignment.center : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      options[index].icon(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: options[index].text(),
                      ),
                    ],
                  ),
                  _buildDivider(index),
                ]),
              )),
          itemCount: options.length,
        ));
  }

  Widget _buildDivider(int index) {
    if (options[index].isHeader) {
      return Padding(padding: EdgeInsets.only(top: 16));
    } else if (index + 1 != options.length) {
      return Divider(
        color: AppTheme.GreyColor.withOpacity(0.25),
        endIndent: 8,
        indent: 8,
      );
    } else {
      return Container();
    }
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
