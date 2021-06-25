import 'package:sonr_app/style/style.dart';
export 'package:sonr_app/pages/register/widgets/textfield.dart';

class RegisterSetupTitleBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? instruction;
  final bool isGradient;

  const RegisterSetupTitleBar({Key? key, required this.title, this.instruction, this.isGradient = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 64.0),
      child: NavigationToolbar(
        centerMiddle: instruction != null,
        middle: AnimatedSlider.fade(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: instruction != null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              instruction != null ? instruction!.light(fontSize: 42) : Container(),
              isGradient ? title.gradient(value: SonrGradient.Theme(radius: 2), size: 48) : title.heading(fontSize: 42),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Width.full, instruction != null ? 142 : 60);
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
        height: 120,
        decoration: BoxDecoration(
            boxShadow: AppTheme.boxShadow,
            color: AppTheme.backgroundColor,
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
