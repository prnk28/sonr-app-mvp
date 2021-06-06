import 'package:get/get.dart';
import 'editor_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'general/fields.dart';

class EditorView extends GetView<EditorController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
        appBar: DesignAppBar(
          centerTitle: true,
          title: controller.title.value.subheading(
            color: Get.theme.focusColor,
            align: TextAlign.start,
          ),
          leading: PlainIconButton(
              icon: controller.status.value.leadingIcon.gradient(size: 32, value: SonrGradients.PhoenixStart), onPressed: controller.handleLeading),
        ),
        body: FadeInLeft(key: ValueKey<EditorFieldStatus>(controller.status.value), child: _buildView(controller.status.value))));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(EditorFieldStatus status) {
    // Edit Name
    if (status == EditorFieldStatus.FieldName) {
      return EditNameView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldName));
    }
    // Edit Phone
    else if (status == EditorFieldStatus.FieldPhone) {
      return EditPhoneView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldPhone));
    }

    // TODO: Edit Addresses
    // else if (status == EditorFieldStatus.FieldAddresses) {
    //   return EditNameView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldName));
    // }

    // TODO: Edit Gender
    // else if (status == EditorFieldStatus.FieldGender) {
    //   return EditNameView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldName));
    // }

    // Default View
    else {
      return GeneralEditorView();
    }
  }
}
