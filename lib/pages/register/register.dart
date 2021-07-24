// Exports
export 'register_controller.dart';
export 'models/field.dart';
export 'models/intro.dart';
export 'models/type.dart';

// Imports
import 'package:sonr_app/pages/register/views/perm_view.dart';
import 'package:sonr_app/pages/register/views/start_view.dart';
import 'package:sonr_app/style/style.dart';
import 'models/field.dart';
import 'models/type.dart';
import 'register_controller.dart';
import 'views/setup_view.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Obx(
        () => AnimatedSlider.slideRight(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );
  }

  Widget _buildView(RegisterPageType status) {
    // Return View
    if (status.isPermissions) {
      return PermissionsView();
    } else if (status.isSetup) {
      return SetupView();
    } else {
      return StartView(key: RegisterPageType.Intro.key);
    }
  }
}

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
              instruction != null ? instruction!.light(fontSize: 42, color: AppTheme.ItemColor) : Container(),
              isGradient ? title.gradient(value: AppGradients.Primary(), size: 48) : title.heading(fontSize: 42, color: AppTheme.ItemColor),
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
            boxShadow: AppTheme.RectBoxShadow,
            color: AppTheme.BackgroundColor,
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

/// #### Builds Neumorphic Text Field
class RegisterTextField extends GetView<RegisterController> {
  final FocusNode focusNode;
  final void Function() onEditingComplete;
  final RegisterTextFieldType type;
  final String hint;

  RegisterTextField({
    required this.type,
    required this.hint,
    required this.focusNode,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<TextInputValidStatus>>((status) {
      if (status.value == TextInputValidStatus.Invalid) {
        return buildInvalid(context);
      } else {
        return buildDefault(context);
      }
    }, type.status);
  }

  Widget buildDefault(BuildContext context, {InputDecoration? decoration, bool isError = false}) {
    return Container(
      constraints: BoxConstraints(maxHeight: 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 24),
              alignment: Alignment.centerLeft,
              child: [
                type.label.toUpperCase().lightSpan(
                      color: AppTheme.GreyColor,
                      fontSize: 20,
                    ),
                isError
                    ? " Error".sectionSpan(
                        color: AppColor.Red,
                        fontSize: 20,
                      )
                    : "".lightSpan(),
              ].rich()),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.BackgroundColor,
              borderRadius: BorderRadius.circular(22),
            ),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: TextField(
              style: DisplayTextStyle.Light.style(color: AppTheme.ItemColor, fontSize: 20),
              keyboardType: type.textInputType,
              autofocus: type.autoFocus,
              textInputAction: type.textInputAction,
              autocorrect: type.autoCorrect,
              inputFormatters: type.inputFormatters,
              textCapitalization: type.textCapitalization,
              focusNode: focusNode,
              onEditingComplete: () => onEditingComplete(),
              onChanged: (val) {
                type.value(val);
                type.value.refresh();
              },
              decoration: decoration != null
                  ? decoration
                  : InputDecoration.collapsed(
                      hintText: hint,
                      hintStyle: DisplayTextStyle.Paragraph.style(color: AppTheme.GreyColor, fontSize: 20),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInvalid(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: 1.seconds,
      builder: (context, animation, child) => Transform.translate(
        offset: shakeOffset(animation),
        child: child,
      ),
      child: buildDefault(context,
          isError: true,
          decoration: InputDecoration.collapsed(
              border: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.Red, width: 4)),
              hintText: hint,
              hintStyle: DisplayTextStyle.Paragraph.style(color: AppTheme.ItemColor.withOpacity(0.75), fontSize: 20))),
    );
  }

  /// #### Get Animated Offset for Shake Method
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }
}
