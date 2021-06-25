import 'package:sonr_app/style.dart';
import 'package:sonr_app/pages/register/register.dart';

/// @ Builds Neumorphic Text Field
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
                      color: AppTheme.greyColor,
                      fontSize: 20,
                    ),
                isError
                    ? " Error".sectionSpan(
                        color: SonrColor.Critical,
                        fontSize: 20,
                      )
                    : "".lightSpan(),
              ].rich()),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(22),
            ),
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: TextField(
              style: DisplayTextStyle.Paragraph.style(color: AppTheme.itemColor, fontSize: 20),
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
                      hintStyle: DisplayTextStyle.Subheading.style(color: AppTheme.greyColor, fontSize: 20),
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
              border: UnderlineInputBorder(borderSide: BorderSide(color: SonrColor.Critical, width: 4)),
              hintText: hint,
              hintStyle:
                  TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: Preferences.isDarkMode ? Colors.white38 : Colors.black38))),
    );
  }

  /// @ Get Animated Offset for Shake Method
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }
}
