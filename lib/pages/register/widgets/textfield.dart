import 'package:sonr_app/style.dart';

import '../register_controller.dart';

/// @ Builds Neumorphic Text Field
class RegisterTextField extends GetView<RegisterController> {
  final String label;
  final String hint;
  final RxString value;
  final FocusNode focusNode;
  final bool autoFocus;
  final bool autoCorrect;
  final TextInputAction textInputAction;
  final Rx<TextInputValidStatus> status;
  final void Function()? onEditingComplete;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  factory RegisterTextField.firstName({
    required String hint,
    required void Function() onEditingComplete,
    required FocusNode focusNode,
  }) {
    return RegisterTextField(
        value: Get.find<RegisterController>().firstName,
        hint: hint,
        label: "",
        focusNode: focusNode,
        textInputType: TextInputType.name,
        autoFocus: true,
        autoCorrect: false,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        ],
        textInputAction: TextInputAction.next,
        status: Get.find<RegisterController>().firstNameStatus);
  }

  factory RegisterTextField.lastName({
    required String hint,
    required void Function() onEditingComplete,
    required FocusNode focusNode,
  }) {
    return RegisterTextField(
      value: Get.find<RegisterController>().lastName,
      hint: hint,
      label: "",
      focusNode: focusNode,
      textInputType: TextInputType.name,
      autoFocus: true,
      autoCorrect: false,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
      ],
      textInputAction: TextInputAction.done,
      status: Get.find<RegisterController>().lastNameStatus,
    );
  }

  factory RegisterTextField.email({
    required String hint,
    required void Function() onEditingComplete,
    required FocusNode focusNode,
  }) {
    return RegisterTextField(
      value: Get.find<RegisterController>().lastName,
      hint: hint,
      label: "",
      focusNode: focusNode,
      textInputType: TextInputType.emailAddress,
      autoFocus: true,
      autoCorrect: false,
      inputFormatters: [],
      textInputAction: TextInputAction.done,
      status: Get.find<RegisterController>().lastNameStatus,
    );
  }

  factory RegisterTextField.phoneNumber({
    required String hint,
    required void Function() onEditingComplete,
    required FocusNode focusNode,
  }) {
    return RegisterTextField(
        value: Get.find<RegisterController>().lastName,
        hint: hint,
        label: "",
        focusNode: focusNode,
        textInputType: TextInputType.phone,
        autoFocus: true,
        autoCorrect: false,
        textInputAction: TextInputAction.done,
        status: Get.find<RegisterController>().lastNameStatus,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ]);
  }

  RegisterTextField({
    required this.value,
    required this.hint,
    required this.label,
    required this.focusNode,
    required this.status,
    required this.inputFormatters,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.next,
    this.autoFocus = false,
    this.autoCorrect = false,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<TextInputValidStatus>>((status) {
      if (status.value == TextInputValidStatus.Invalid) {
        return buildInvalid(context);
      } else {
        return buildDefault(context);
      }
    }, status);
  }

  Widget buildDefault(BuildContext context, {InputDecoration? decoration, bool isError = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 24),
            alignment: Alignment.centerLeft,
            child: [
              label.toUpperCase().lightSpan(
                    color: SonrTheme.greyColor,
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
          decoration: BoxDecoration(color: SonrTheme.foregroundColor, borderRadius: BorderRadius.circular(22)),
          margin: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: TextField(
            style: DisplayTextStyle.Paragraph.style(color: SonrTheme.itemColor, fontSize: 20),
            keyboardType: textInputType,
            autofocus: autoFocus,
            textInputAction: textInputAction,
            autocorrect: autoCorrect,
            inputFormatters: inputFormatters,
            textCapitalization: TextCapitalization.words,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            onChanged: (val) => value(val),
            decoration: decoration != null
                ? decoration
                : InputDecoration.collapsed(
                    hintText: hint,
                    hintStyle: DisplayTextStyle.Subheading.style(color: SonrTheme.greyColor, fontSize: 20),
                  ),
          ),
        )
      ],
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
                  TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w400, color: UserService.isDarkMode ? Colors.white38 : Colors.black38))),
    );
  }

  /// @ Get Animated Offset for Shake Method
  Offset shakeOffset(double animation) {
    var shake = 2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());
    return Offset(18 * shake, 0);
  }
}
