import 'package:get/get.dart';
import 'package:sonr_app/views/home/profile/profile.dart';

import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/sonr_social.dart';

// ** Focused Tile ** //
class FocusedTile {
  final int index;
  final bool isActive;
  FocusedTile(this.index, this.isActive);
}

// ** Tile Create Step Class ** //
class TileStep {
  // @ References
  int _step = 0;
  int get current => _step;
  set current(int s) => _step;
  bool get hasCurrent => _step != null;

  // @ Form -> Provider
  Contact_SocialTile_Provider _provider;
  Contact_SocialTile_Provider get provider => _provider;
  set provider(Contact_SocialTile_Provider s) => _provider;
  bool get hasProvider => _provider != null;

  // @ Form -> User Data
  SocialUser _user;
  SocialUser get user => _user;
  set user(SocialUser s) => _user;
  bool get hasUser => _user != null;

  // @ Form -> Privacy
  bool _isPrivate;
  bool get isPrivate => _isPrivate;
  set isPrivate(bool s) => _isPrivate;
  bool get hasPrivate => _isPrivate != null;

  // @ Form -> Type
  Contact_SocialTile_Type _type;
  Contact_SocialTile_Type get type => _type;
  set type(Contact_SocialTile_Type s) => _type;
  bool get hasType => _type != null;

  // @ Properties
  final Function next;
  final Function previous;
  final Function save;

  TileStep(this.next, this.previous, this.save);

  // ^ Adjusted Container Height ^
  double get height {
    var kBaseModifier = 260.0;
    if (current == 0) {
      var heightModifier = 200 + kBaseModifier;
      return Get.height - heightModifier;
    } else if (current == 1) {
      var heightModifier = 250 + kBaseModifier;
      return Get.height - heightModifier;
    } else {
      var heightModifier = 200 + kBaseModifier;
      return Get.height - heightModifier;
    }
  }

  // ^ Adjusted View Margin ^
  double get verticalMargin {
    if (current == 0) {
      return 10;
    } else if (current == 1) {
      return 15;
    } else {
      return 10;
    }
  }

  // ^ Presented View by Step ^
  Widget get currentView {
    if (current == 2) {
      return SetTypeView();
    } else if (current == 1) {
      return SetInfoView();
    } else {
      return DropdownAddView();
    }
  }

  // ^ Bottom Buttons for View by Step ^
  Widget get bottomButtons {
    //  Step Three: Cancel and Confirm
    if (current == 2) {
      return ColorButton.primary(
        text: "Save",
        onPressed: save,
        icon: SonrIcons.CheckAll,
        margin: EdgeInsets.only(left: 60, right: 80),
      );
    }
    // Step Two: Dual Bottom Buttons, Back and Next
    else if (current == 1) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        PlainButton(text: "Back", onPressed: previous, icon: SonrIcons.Backward),
        ColorButton.primary(text: "Next", onPressed: next, icon: SonrIcons.Forward, iconPosition: WidgetPosition.Right),
      ]);
    }
    // Step One: Top Cancel Button
    else {
      return ColorButton.primary(
        text: "Next",
        onPressed: next,
        icon: SonrIcons.Forward,
        margin: EdgeInsets.only(left: 60, right: 80),
        iconPosition: WidgetPosition.Right,
      );
    }
  }

  Contact_SocialTile_Links get links {
    return provider.links(user.username);
  }
}
