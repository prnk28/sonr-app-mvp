// @ PeerStatus Enum
import 'package:sonr_app/style/style.dart';

enum PersonalViewStatus {
  Viewing,
  EditView,
  FieldName,
  FieldGender,
  FieldPhone,
  FieldAddresses,
  AddSocial,
  AddPicture,
  ViewPicture,
  NeedCameraPermissions
}

extension PersonalViewStatusUtils on PersonalViewStatus {
  bool get isEditing => this == PersonalViewStatus.EditView;
  bool get isViewing => this == PersonalViewStatus.Viewing;
  bool get isAddingPicture => this == PersonalViewStatus.AddPicture;
  bool get isAddingSocial => this == PersonalViewStatus.AddSocial;
  bool get hasPermissions => this != PersonalViewStatus.NeedCameraPermissions;
  bool get hasCaptured => this == PersonalViewStatus.ViewPicture;

  static PersonalViewStatus statusFromPermissions(bool val) {
    return val ? PersonalViewStatus.AddPicture : PersonalViewStatus.NeedCameraPermissions;
  }
}

enum EditorFieldStatus {
  Default,
  FieldName,
  FieldGender,
  FieldPhone,
  FieldAddresses,
}

extension EditorFieldStatusUtils on EditorFieldStatus {
  String get name {
    switch (this) {
      case EditorFieldStatus.Default:
        return "Settings";
      case EditorFieldStatus.FieldName:
        return "Names";
      case EditorFieldStatus.FieldGender:
        return "Gender";
      case EditorFieldStatus.FieldPhone:
        return "Phones";
      case EditorFieldStatus.FieldAddresses:
        return "Addresses";
    }
  }

  bool get isMainView => this == EditorFieldStatus.Default;
  bool get isNotMainView => this != EditorFieldStatus.Default;

  IconData get leadingIcon => this.isMainView ? SimpleIcons.Close : SimpleIcons.Backward;
}
