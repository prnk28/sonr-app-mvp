import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_social.dart';
import 'package:get/get.dart';
import 'package:sonr_core/sonr_core.dart';

// @ PeerStatus Enum
enum ProfileState { Viewing, Editing }

class ProfileController extends GetxController {
  // Properties
  final state = ProfileState.Viewing.obs;
  final focused = FocusedTile(-1, false).obs;
  final options = SonrSocial.options(UserService.socials);

  // References
  final step = Rx<TileStep>();
  final pageController = PageController();

  // References
  bool _isEditing = false;

  // ** Initialize Method ** //
  onInit() async {
    step(TileStep(nextStep, previousStep, saveTile));
    super.onInit();
  }

  // -- Set Privacy -- //
  isPrivate(bool value) {
    step.update((val) {
      val.isPrivate = value;
    });
    step.refresh();
  }

  // -- Set Current Provider -- //
  provider(int index) {
    step.update((val) {
      val.provider = options[index];
    });
    step.refresh();
  }

  // -- Set Tile Type -- //
  type(Contact_SocialTile_Type type) {
    step.update((val) {
      val.type = type;
    });
    step.refresh();
  }

  // -- Set Social User -- //
  user(SocialUser user) {
    step.update((val) {
      val.user = user;
    });
    step.refresh();
  }

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value.current == 0) {
      if (step.value.hasProvider) {
        step.update((val) {
          val.current = 1;
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
        });
        step.refresh();
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value.current == 1) {
      // Update State
      if (step.value.hasUser) {
        step.update((val) {
          val.current = 2;
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
        });
        step.refresh();

        FocusScopeNode currentFocus = FocusScope.of(Get.context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      }
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Add your username or Link your account");
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // Step 2
    if (step.value.current == 1) {
      step.update((val) {
        val.current = 0;
        pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      });
      step.refresh();
    }
    // Step 3
    else if (step.value.current == 2) {
      step.update((val) {
        val.current = 1;
        pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      });
      step.refresh();
    }
  }

  // ^ Finish and Save new Tile ^ //
  saveTile() {
    // Validate
    if (step.value.hasType && step.value.current == 2) {
      // Create Tile from Values
      var tile = Contact_SocialTile(
        username: step.value.user.username,
        isPrivate: step.value.isPrivate,
        provider: step.value.provider,
        type: step.value.type,
        links: step.value.links,
        position: Contact_SocialTile_Position(index: UserService.tileCount),
      );

      // Save to Profile
      UserService.addSocial(tile);
      Get.back(closeOverlays: true);
      reset();
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
    }
  }

  // ^ Resets current info ^
  reset() {
    step(TileStep(nextStep, previousStep, saveTile));
    step.refresh();
  }

  // ^ Toggle Editing Mode ^ //
  toggleEditing() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      state(ProfileState.Editing);
    } else {
      state(ProfileState.Viewing);
    }
  }

  // ^ Expand a Tile  ^ //
  toggleExpand(int index, bool isExpanded) {
    print("Index $index Expanded $isExpanded");
    focused(FocusedTile(index, isExpanded));
    update(['social-grid']);
  }
}
