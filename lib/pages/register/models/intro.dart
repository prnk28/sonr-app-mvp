import 'package:introduction_screen/introduction_screen.dart';
import 'package:sonr_app/style/style.dart';

enum IntroPageType {
  Welcome,
  Universal,
  Secure,
  Start,
}

extension IntroPanelTypeUtils on IntroPageType {
  /// Returns Total Panels
  int get total => IntroPageType.values.length;

  /// Returns this Panels Index
  int get index => IntroPageType.values.indexOf(this);

  /// Returns this InfoPanels page value
  double get page => this.index.toDouble();

  /// Return Next Info Panel
  IntroPageType get next => IntroPageType.values[this.index + 1];

  /// Return Previous Info Panel
  IntroPageType get previous => IntroPageType.values[this.index - 1];

  /// Checks if this Panel is First Panel
  bool get isFirst => this.index == 0;

  /// Checks if this Panel is NOT First Panel
  bool get isNotFirst => this.index != 0;

  /// Checks if this Panel is Last Panel
  bool get isLast => this.index + 1 == this.total;

  /// Checks if this Panel is NOT Last Panel
  bool get isNotLast => this.index + 1 != this.total;

  /// Return Page Decoration for Type
  PageDecoration get pageDecoration {
    return PageDecoration(
      imageAlignment: Alignment.topCenter,
      bodyAlignment: Alignment.bottomCenter,
      titlePadding: EdgeInsets.only(top: isFirst? 128 : 64.0),
    );
  }

  /// Return Image Path for Type
  String get imagePath {
    final basePath = "assets/images/illustrations/";
    switch (this) {
      case IntroPageType.Welcome:
        return basePath + "Welcome.png";
      case IntroPageType.Universal:
        return basePath + "Universal.png";
      case IntroPageType.Secure:
        return basePath + "Secure.png";
      case IntroPageType.Start:
        return basePath + "Start.png";
    }
  }

  /// Returns Decoration for Container Around Image
  BoxDecoration get imageDecoration {
    switch (this) {
      case IntroPageType.Welcome:
        return BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.Black,
              width: 2,
            ));
      case IntroPageType.Universal:
        return BoxDecoration();
      case IntroPageType.Secure:
        return BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.Black,
              width: 2,
            ));
      case IntroPageType.Start:
        return BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColor.Black.withOpacity(0.4),
              width: 2,
            ));
    }
  }

  /// Returns This Panels Page View Model
  PageViewModel pageViewModel() {
    return PageViewModel(
      decoration: this.pageDecoration,
      titleWidget: SlideInUp(
        animate: this.isFirst,
        child: this.title(),
        delay: 50.milliseconds,
        duration: 300.milliseconds,
      ),
      bodyWidget: SlideInUp(
        animate: this.isFirst,
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          child: this.description(),
          margin: EdgeInsets.only(left: 8, bottom: 64),
          height: Height.ratio(0.3),
          alignment: Alignment.topLeft,
        ),
        duration: 300.milliseconds,
        delay: 250.milliseconds,
      ),
      image: Center(
          child: FadeIn(
        delay: 150.milliseconds,
        child: Container(
          margin: EdgeInsets.only(top: 72),
          decoration: this.imageDecoration,
          child: Image.asset(this.imagePath, height: 200.0, fit: BoxFit.fitWidth),
          padding: EdgeInsets.all(42),
        ),
      )),
    );
  }

  /// Returns this Panels Title as Heading Widget
  Widget title() {
    final color = AppColor.Black;
    switch (this) {
      case IntroPageType.Welcome:
        return 'Welcome'.heading(color: color, fontSize: 36);
      case IntroPageType.Universal:
        return 'Universal'.heading(color: color, fontSize: 36);
      case IntroPageType.Secure:
        return 'Security First'.heading(color: color, fontSize: 36);
      case IntroPageType.Start:
        return 'Get Started'.heading(color: color, fontSize: 36);
    }
  }

  /// Returns this Panels Description as Rich Text
  Widget description() {
    final color = AppColor.DarkGrey;
    final size = 20.0;
    switch (this) {
      case IntroPageType.Welcome:
        return [
          'Sonr has '.lightSpan(fontSize: size, color: color),
          'NO '.subheadingSpan(fontSize: size, color: color),
          'File Size Limits. Works like Airdrop Nearby and like Email when nobody is around.'.lightSpan(
            fontSize: size,
            color: color,
          )
        ].rich();
      case IntroPageType.Universal:
        return 'Runs Natively on iOS, Android, MacOS, Windows and Linux.'.light(fontSize: size, color: color);
      case IntroPageType.Secure:
        return 'Completely Encrypted Communication. All data is verified and signed.'.light(fontSize: size, color: color);
      case IntroPageType.Start:
        return 'Lets Continue by selecting your Sonr Name.'.light(fontSize: size, color: color);
    }
  }
}

enum PermsPageType {
  Location,
  Gallery,
  Notifications,
}

extension PermsPageTypeUtils on PermsPageType {
  /// Return Image Path for Type
  String get imagePath {
    final basePath = "assets/images/illustrations/";
    switch (this) {
      case PermsPageType.Location:
        return basePath + "LocationPerm.png";
      case PermsPageType.Gallery:
        return basePath + "MediaPerm.png";
      case PermsPageType.Notifications:
        return basePath + "Secure.png";
    }
  }

  /// Returns This Panels Page View Model
  PageViewModel pageViewModel() {
    return PageViewModel(
        decoration: PageDecoration(
          fullScreen: true,
        ),
        titleWidget: Container(),
        bodyWidget: Container(),
        image: Container(
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fitHeight,
              ),
            )));
  }
}
