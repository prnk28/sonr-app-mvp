import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/style.dart';
export 'package:sonr_app/pages/register/widgets/textfield.dart';

class InfoPanel extends StatelessWidget {
  final InfoPanelType type;
  final String? buttonText;
  final Function? onButtonPressed;
  final CrossAxisAlignment textAlignment;

  const InfoPanel({
    Key? key,
    required this.type,
    this.buttonText,
    this.onButtonPressed,
    this.textAlignment = CrossAxisAlignment.start,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInUpBig(
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(color: SonrColor.Black.withOpacity(0.7), borderRadius: BorderRadius.circular(22)),
        margin: EdgeInsets.only(top: Height.ratio(0.675), left: 20, right: 20, bottom: Height.ratio(0.05)),
        padding: EdgeInsets.only(left: 24, right: 24),
        width: 1920 / InfoPanelType.values.length,
        child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(
              maxWidth: Width.full,
              maxHeight: Height.ratio(0.4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: textAlignment,
              children: [
                type.title(),
                type.description(),
                type.footer(),
              ],
            )),
      ),
    );
  }
}

class PermPanel extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final String imagePath;
  final Color buttonTextColor;
  const PermPanel({Key? key, required this.buttonText, required this.onPressed, required this.imagePath, required this.buttonTextColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ColorButton.neutral(
        onPressed: onPressed,
        text: buttonText,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}

class FormPanel extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets margin;
  final EdgeInsets padding;
  const FormPanel({Key? key, required this.children, required this.margin, required this.padding}) : super(key: key);
  @override
  factory FormPanel.sName({required List<Widget> children}) {
    return FormPanel(
      children: children,
      margin: EdgeInsets.only(bottom: 8, top: 72),
      padding: EdgeInsets.zero,
    );
  }

  factory FormPanel.contact({required List<Widget> children}) {
    return FormPanel(
      children: children,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.zero,
    );
  }

  Widget build(BuildContext context) {
    return Container(
      width: Width.full,
      height: Height.full,
      margin: margin,
      padding: padding,
      child: Column(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}

class PagePanel extends StatelessWidget {
  final List<Widget> children;

  const PagePanel({Key? key, required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      width: Width.full,
      height: Height.full,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class RegisterTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? instruction;
  final bool isGradient;

  const RegisterTitleBar({Key? key, required this.title, this.instruction, this.isGradient = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 64.0),
      child: NavigationToolbar(
        centerMiddle: instruction != null,
        middle: AnimatedSlideSwitcher.fade(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: instruction != null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              instruction != null ? instruction!.light(fontSize: 48) : Container(),
              isGradient ? title.gradient(value: SonrGradient.Theme(radius: 2), size: 48) : title.heading(fontSize: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Width.full, instruction != null ? 150 : 60);
}

class RegisterBottomSheet extends StatelessWidget {
  final Widget? leftButton;
  final Widget? rightButton;

  const RegisterBottomSheet({Key? key, this.leftButton, this.rightButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (leftButton != null && rightButton != null) {
      return Container(
        padding: EdgeInsets.all(8),
        width: Get.width,
        height: 106,
        decoration: BoxDecoration(
            boxShadow: SonrTheme.boxShadow,
            color: SonrTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(37),
              topRight: Radius.circular(37),
            )),
        child: Row(
          children: [leftButton!, rightButton!],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
        ),
      );
    }
    return Container();
  }
}
