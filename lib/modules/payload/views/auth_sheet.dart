// Imports
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/modules/payload/payload.dart';
import 'package:sonr_app/style/style.dart';

/// #### TransferView: Builds Invite View based on InviteRequest Payload Type
class InviteRequestSheet extends StatelessWidget {
  final InviteRequest invite;

  const InviteRequestSheet({Key? key, required this.invite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
        padding: EdgeInsets.only(left: 8, right: 8),
        height: 475,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 24),
        child: Column(
          children: [
            _InviteRequestFileHeader(
              file: invite.file,
              payload: invite.payload,
              profile: invite.from.active.profile,
            ),
            _buildView(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ColorButton.primary(
                onPressed: () {
                  ReceiverService.decide(true);
                },
                text: "Accept",
                icon: SimpleIcons.Check,
                margin: EdgeInsets.symmetric(horizontal: 54),
              ),
            ),
          ],
        ));
  }

  // Builds View By Payload
  Widget _buildView() {
    if (invite.payload.isTransfer) {
      return Container(
        height: Height.ratio(0.275),
        width: Get.width,
        decoration: BoxDecoration(color: AppTheme.BackgroundColor, borderRadius: BorderRadius.circular(22)),
        padding: EdgeInsets.all(8),
        child: FileContent(
          width: Width.ratio(0.8),
          height: Height.ratio(0.3),
          file: invite.file,
        ),
      );
    } else {
      return URLAuthView(invite);
    }
  }
}

/// #### Header: Auth Invite File Header
class _InviteRequestFileHeader extends StatelessWidget {
  final Payload payload;
  final Profile profile;
  final SFile file;

  const _InviteRequestFileHeader({Key? key, required this.payload, required this.profile, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: CircleContainer(
                    margin: EdgeInsets.only(top: 8, left: 8),
                    padding: EdgeInsets.all(4),
                    child: Container(
                      width: 64,
                      height: 64,
                      child: profile.hasPicture()
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                            )
                          : SimpleIcons.User.gradient(size: 42),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Tooltip(
                  message: profile.sName + ".snr/",
                  child: "View SName".light(fontSize: 16, color: AppColor.Blue),
                  height: 50,
                  decoration: BoxDecoration(color: AppTheme.ItemColor.withOpacity(0.9), borderRadius: BorderRadius.circular(22)),
                  padding: const EdgeInsets.all(16.0),
                  preferBelow: false,
                  textStyle: DisplayTextStyle.Light.style(color: AppTheme.ItemColorInversed, fontSize: 24),
                  showDuration: 1800.milliseconds,
                  waitDuration: 0.milliseconds,
                ),
              )
            ],
          ),
        ),

        // From Information
        Container(
            width: Width.ratio(0.6),
            child: [
              profile.firstName.capitalizeFirst!.headingSpan(
                fontSize: 20,
                color: AppTheme.ItemColor,
              ),
              " wants to share an ".lightSpan(
                fontSize: 19,
                color: AppTheme.ItemColor,
              ),
              file.prettyType().headingSpan(
                    fontSize: 20,
                    color: AppTheme.ItemColor,
                  ),
              " of size ".lightSpan(
                fontSize: 19,
                color: AppTheme.ItemColor,
              ),
              file.prettySize().headingSpan(
                    fontSize: 20,
                    color: AppTheme.ItemColor,
                  )
            ].rich())
      ]),
    );
  }
}
