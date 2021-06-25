import 'package:introduction_screen/introduction_screen.dart';
import 'package:sonr_app/style.dart';

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

  /// Return Padding for Content
  EdgeInsets get padding {
    if (this.isLast) {
      return EdgeInsets.only(top: 72.0, bottom: 24.0);
    } else {
      return EdgeInsets.only(top: 72.0, bottom: 24.0);
    }
  }

  PageDecoration get pageDecoration {
    return PageDecoration(
      titlePadding: EdgeInsets.only(top: 72.0, bottom: 24.0),

    );
  }

  /// Returns This Panels Page View Model
  PageViewModel pageViewModel() {
    return PageViewModel(
      decoration: PageDecoration(
        titlePadding: padding,
      ),
      titleWidget: this.title(),
      bodyWidget: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: this.description(),
      ),
      image: Center(
        child: Image.network("https://domaine.com/image.png", height: 175.0),
      ),
    );
  }

  /// Returns this Panels Title as Heading Widget
  Widget title() {
    final color = SonrColor.Black;
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
    final color = SonrColor.Grey;
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
        return ['Runs Natively on iOS, Android, MacOS, Windows and Linux.'.lightSpan(fontSize: size, color: color)].rich();
      case IntroPageType.Secure:
        return ['Completely Encrypted Communication. All data is verified and signed.'.lightSpan(fontSize: size, color: color)].rich();
      case IntroPageType.Start:
        return ['Lets Continue by selecting your Sonr Name.'.lightSpan(fontSize: size, color: color)].rich();
    }
  }
}
