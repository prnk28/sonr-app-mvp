import 'package:sonr_app/style/style.dart';
import 'register_controller.dart';

class FormPage extends GetView<RegisterController> {
  final hintName = SonrTextField.hintName();
  final lastNameFocus = FocusNode();
  final scrollController = ScrollController();

  FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return SonrScaffold(
          body: Container(
            width: Get.width,
            height: Get.height,
            margin: EdgeInsets.only(bottom: 8, top: 72),
            child: CustomScrollView(controller: scrollController, slivers: [
              SliverToBoxAdapter(
                child: Container(
                  child: SonrAssetLogo.Top.widget,
                  height: 128,
                ),
              ),
              SingleChildScrollView(
                controller: scrollController,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ****************** //
                      // ** <First Name> ** //
                      // ****************** //
                      SonrTextField(
                          label: "First Name",
                          hint: hintName.item1,
                          value: controller.firstName.value,
                          status: controller.firstNameStatus,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autoFocus: true,
                          autoCorrect: false,
                          onEditingComplete: () {
                            controller.firstName(controller.firstName.value.capitalizeFirst!);
                            controller.firstName.refresh();
                            lastNameFocus.requestFocus();
                            scrollController.animateTo(40, duration: 250.milliseconds, curve: Curves.easeOut);
                          },
                          onChanged: (String value) {
                            controller.firstName(value);
                            controller.firstName.refresh();
                          }),

                      // ***************** //
                      // ** <Last Name> ** //
                      // ***************** //
                      SonrTextField(
                          label: "Last Name",
                          hint: hintName.item2,
                          textInputAction: TextInputAction.next,
                          value: controller.lastName.value,
                          textCapitalization: TextCapitalization.words,
                          focusNode: lastNameFocus,
                          status: controller.lastNameStatus,
                          autoCorrect: false,
                          onEditingComplete: () {
                            controller.lastName(controller.lastName.value.capitalizeFirst!);
                            controller.lastName.refresh();
                            lastNameFocus.unfocus();
                          },
                          onChanged: (String value) {
                            controller.lastName(value);
                            controller.lastName.refresh();
                          }),

                      // ********************* //
                      // ** <Submit Button> ** //
                      // ********************* //
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: ColorButton.primary(
                            margin: EdgeWith.horizontal(80),
                            icon: SonrIcons.Check,
                            text: "Get Started",
                            onPressed: () {
                              controller.setContact();
                            },
                            //margin: EdgeInsets.only(top: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
