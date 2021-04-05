import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';

class AlbumsDropdown extends StatelessWidget {
  final RxInt index;
  final EdgeInsets margin;
  final double width = Get.width - 100;
  final double height;
  AlbumsDropdown({@required this.index, this.margin = const EdgeInsets.only(left: 12, right: 12), this.height = 60});
  @override
  Widget build(BuildContext context) {
    return SonrDropdown(
        _buildItems(MediaService.albums),
        SonrDropdownItem(true, "All",
            icon: SonrIcon.gradient(
                Icons.all_inbox_rounded, UserService.isDarkMode ? FlutterGradientNames.premiumWhite : FlutterGradientNames.premiumDark,
                size: 20)),
        index,
        margin,
        width ?? Get.width - 250,
        height,
        style: SonrStyle.dropDownCurved,
        overlayWidth: 70,
        overlayHeight: 100,
        selectedFlex: 2,
        selectedIconPosition: WidgetPosition.Left);
  }

  // # Build Media Album Items
  List<SonrDropdownItem> _buildItems(List<MediaAlbum> data) {
    return List<SonrDropdownItem>.generate(data.length, (index) {
      if (data[index].name != null) {
        // Initialize
        var collection = data[index];
        var hasIcon = false;
        var icon;

        // @ Set Icon for Generated Albums
        var adjName = collection.name.toLowerCase();
        // All
        if (adjName == 'all') {
          hasIcon = true;
          icon = SonrIcon.gradient(
              Icons.all_inbox_rounded, UserService.isDarkMode ? FlutterGradientNames.premiumWhite : FlutterGradientNames.premiumDark,
              size: 20);
        }
        // Sonr
        else if (adjName == 'sonr') {
          hasIcon = true;
          icon = SonrIcon.sonr;
        }
        // Download
        else if (adjName == 'download') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.download_rounded, FlutterGradientNames.orangeJuice, size: 20);
        }
        // Screenshots
        else if (adjName == 'screenshots') {
          hasIcon = true;
          icon = SonrIcon.screenshots;
        }
        // Favorites
        else if (adjName == 'favorites') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.star_half_rounded, FlutterGradientNames.fruitBlend, size: 20);
        }
        // Panoramas
        else if (adjName == 'panoramas') {
          hasIcon = true;
          icon = SonrIcon.panorama;
        }
        // Pictures
        else if (adjName == 'pictures') {
          hasIcon = true;
          icon = SonrIcon.photos;
        }
        // Videos
        else if (adjName == 'movies' || adjName == 'videos') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.movie_creation_outlined, FlutterGradientNames.lilyMeadow, size: 20);
        }
        // Recents
        else if (adjName == 'recent' || adjName == 'recents') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.timelapse, FlutterGradientNames.crystalline, size: 20);
        }

        // Other
        else {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.album_rounded, FlutterGradientNames.sugarLollipop, size: 20);
        }
        // Return Item
        return SonrDropdownItem(hasIcon, collection.name, icon: icon);
      } else {
        return null;
      }
    });
  }
}
