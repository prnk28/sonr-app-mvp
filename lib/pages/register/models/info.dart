import 'package:dots_indicator/dots_indicator.dart';
import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';
import 'package:sonr_app/pages/register/register.dart';

enum InfoPanelType {
  Welcome,
  Universal,
  Secure,
  Start,
}

extension InfoPanelTypeUtils on InfoPanelType {
  /// Returns Total Panels
  int get total => InfoPanelType.values.length;

  /// Returns this Panels Index
  int get index => InfoPanelType.values.indexOf(this);

  /// Returns this InfoPanels page value
  double get page => this.index.toDouble();

  /// Return Next Info Panel
  InfoPanelType get next => InfoPanelType.values[this.index + 1];

  /// Return Previous Info Panel
  InfoPanelType get previous => InfoPanelType.values[this.index - 1];

  /// Checks if this Panel is Last Panel
  bool get isLast => this.index + 1 == this.total;

  /// Checks if this Panel is Last Panel
  bool get isNotLast => this.index + 1 != this.total;

  /// Returns this Panels Title as Heading Widget
  Widget title() {
    final color = SonrColor.White;
    switch (this) {
      case InfoPanelType.Welcome:
        return 'Welcome'.heading(color: color);
      case InfoPanelType.Universal:
        return 'Universal'.heading(color: color);
      case InfoPanelType.Secure:
        return 'Security First'.heading(color: color);
      case InfoPanelType.Start:
        return 'Get Started'.heading(color: color);
    }
  }

  /// Returns this Panels Description as Rich Text
  Widget description() {
    final color = SonrColor.White;
    final size = 20.0;
    switch (this) {
      case InfoPanelType.Welcome:
        return [
          'Sonr has '.paragraphSpan(fontSize: size, color: color),
          'NO '.lightSpan(fontSize: size, color: color),
          'File Size Limits. Works like Airdrop Nearby and like Email when nobody is around.'.paragraphSpan(
            fontSize: size,
            color: color,
          )
        ].rich();
      case InfoPanelType.Universal:
        return ['Runs Natively on iOS, Android, MacOS, Windows and Linux.'.paragraphSpan(fontSize: size, color: color)].rich();
      case InfoPanelType.Secure:
        return ['Completely Encrypted Communication. All data is verified and signed.'.paragraphSpan(fontSize: size, color: color)].rich();
      case InfoPanelType.Start:
        return ['Lets Continue by selecting your Sonr Name.'.paragraphSpan(fontSize: size, color: color)].rich();
    }
  }

  /// Builds Child for this Info Panel
  Widget footer() {
    // Build Dots
    if (this.isNotLast) {
      return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DotsIndicator(
                dotsCount: InfoPanelType.values.length,
                position: index.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(8.0),
                  activeSize: const Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ActionButton(
                  onPressed: () {
                    Get.find<RegisterController>().nextPanel(this.next);
                  },
                  iconData: SonrIcons.Forward,
                ),
              )
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 36),
          alignment: Alignment.bottomCenter,
          child: ColorButton(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
                border: Border.all(width: 2, color: Color(0xffE7E7E7))),
            onPressed: () {
              Get.find<RegisterController>().nextPage(RegisterPageType.Name);
            },
            pressedScale: 1.1,
            child: "Continue".heading(
              fontSize: 20,
              color: SonrColor.White,
            ),
          ));
    }
  }
}
