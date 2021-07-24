import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/pages/register/register.dart';
import '../models/status.dart';

class SetupView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.ForegroundColor,
        appBar: RegisterSetupTitleBar(
          title: controller.status.value.title,
          instruction: controller.status.value.instruction,
          isGradient: controller.status.value.isGradient,
        ),
        body: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                _NamePage(key: RegisterPageType.Name.key),
                _BackupCodeView(key: RegisterPageType.Backup.key),
                _ProfileSetupView(key: RegisterPageType.Contact.key),
              ],
              controller: Get.find<RegisterController>().setupPageController,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: controller.status.value != RegisterPageType.Name
                  ? RegisterBottomSheet(
                      leftButton: controller.status.value.leftButton(),
                      rightButton: controller.status.value.rightButton(),
                    )
                  : null,
            ),
          ],
        )));
  }
}

class _NamePage extends GetView<RegisterController> {
  _NamePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hint = TextUtils.hintName.item1.toLowerCase();
    return SingleChildScrollView(
      reverse: true,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: Get.width,
            margin: EdgeInsets.only(left: 24),
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Sonr Name".toUpperCase().light(
                      color: AppTheme.GreyColor,
                      fontSize: 20,
                    ),
                Obx(() => Container(
                      child: controller.sName.value.length > 0
                          ? ActionButton(
                              onPressed: () {
                                controller.sName("");
                                controller.sName.refresh();
                              },
                              iconData: SimpleIcons.Clear)
                          : Container(),
                    ))
              ],
            )),
        Container(
            decoration: BoxDecoration(color: AppTheme.BackgroundColor, borderRadius: BorderRadius.circular(22)),
            margin: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: ObxValue<RxDouble>(
                (leftPadding) => Stack(children: [
                      TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z]")),
                        ],
                        style: DisplayTextStyle.Paragraph.style(color: AppTheme.ItemColor, fontSize: 24),
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        autocorrect: false,
                        showCursor: false,
                        textCapitalization: TextCapitalization.none,
                        onEditingComplete: controller.setName,
                        onChanged: (val) {
                          final length = controller.checkName(val);
                          if (length > 0) {
                            leftPadding(length);
                          } else {
                            leftPadding(hint.size(DisplayTextStyle.Paragraph, fontSize: 24).width + 1);
                          }
                        },
                        decoration: InputDecoration.collapsed(hintText: hint),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: leftPadding.value),
                        child: Text(
                          ".snr/",
                          style: DisplayTextStyle.Subheading.style(color: AppTheme.ItemColor, fontSize: 24),
                        ),
                      ),
                    ]),
                (hint.length * 12.0).obs)),
        Padding(padding: EdgeInsets.all(8)),
        _NameStatus(),
        Padding(padding: EdgeInsets.all(200))
      ]),
    );
  }
}

class _NameStatus extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.nameStatus.value == NameStatus.Default || controller.sName.value.length == 0
        ? Container(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "- Must be more than 3 characters".light(
                fontSize: 14,
                color: AppTheme.GreyColor,
              ),
              "- No Numbers, Spaces, and Special Characters.".light(
                fontSize: 14,
                color: AppTheme.GreyColor,
              ),
              "- Ideally a Combo of First & Last Name.".light(
                fontSize: 14,
                color: AppTheme.GreyColor,
              ),
            ],
          ))
        : Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(minWidth: 140, maxWidth: 285),
            child: Container(
              child: Center(
                child: DashedBox(
                  strokeWidth: 1,
                  color: AppTheme.GreyColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      controller.nameStatus.value.icon(),
                      Padding(padding: EdgeInsets.only(left: 4)),
                      controller.nameStatus.value.label(),
                    ]),
                  ),
                ),
              ),
            ),
          ));
  }
}

class _BackupCodeView extends GetView<RegisterController> {
  _BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.keyboardHide();
    return Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.zero,
        width: Width.full,
        height: Height.full,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
                  AppRoute.snack(SnackArgs.alert(
                      title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(SimpleIcons.Copy, color: Colors.white)));
                },
                child: BoxContainer(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: ActionButton(
                          iconData: SimpleIcons.Info,
                          onPressed: () {
                            AppRoute.alert(
                                title: "About Code",
                                description:
                                    "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account.");
                          },
                        ),
                      ),
                      Divider(
                        color: AppTheme.DividerColor,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 24),
                        child: controller.mnemonic.value.gradient(value: DesignGradients.CrystalRiver, size: 32),
                      ),
                    ],
                  ),
                )),
            Padding(padding: EdgeInsets.all(96)),
          ],
        ));
  }
}

class _ProfileSetupView extends GetView<RegisterController> {
  final hintName = TextUtils.hintName;
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _ProfileSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        primary: true,
        reverse: true,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(padding: EdgeInsets.all(8)),
          // CircleContainer(
          //   alignment: Alignment.center,
          //   padding: EdgeInsets.all(4),
          //   child: Container(
          //     alignment: Alignment.center,
          //     child: SonrIcons.Avatar.greyWith(size: 100),
          //   ),
          // ),
          RegisterTextField(
            type: RegisterTextFieldType.FirstName,
            focusNode: firstNameFocus,
            hint: hintName.item1,
            onEditingComplete: () {
              firstNameFocus.unfocus();
              lastNameFocus.requestFocus();
            },
          ),
          RegisterTextField(
            type: RegisterTextFieldType.LastName,
            focusNode: lastNameFocus,
            hint: hintName.item2,
            onEditingComplete: () {
              controller.setContact();
            },
          ),
          Padding(padding: EdgeInsets.all(200))
        ]),
      ),
    );
  }
}
