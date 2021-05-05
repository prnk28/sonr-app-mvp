import '../theme.dart';
import 'package:sonr_app/data/data.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class SonrGradient {
  // * Constructer * //
  static LinearGradient _bottomUp(List<Color> colors) =>
      LinearGradient(colors: colors, begin: Alignment.bottomCenter, end: Alignment.topCenter, tileMode: TileMode.clamp);

  // ^ General Gradients ^ //
  static Gradient get bulbDark => FlutterGradients.findByName(FlutterGradientNames.amourAmour);
  static Gradient get bulbLight => FlutterGradients.findByName(FlutterGradientNames.malibuBeach);
  static Gradient get logo => FlutterGradients.fabledSunset(tileMode: TileMode.decal);

  // ^ Generates Random Gradient for Progress View ^ //
  static Gradient get Progress {
    var name = <FlutterGradientNames>[
      FlutterGradientNames.amyCrisp,
      FlutterGradientNames.sugarLollipop,
      FlutterGradientNames.summerGames,
      FlutterGradientNames.supremeSky,
      FlutterGradientNames.juicyCake,
      FlutterGradientNames.northMiracle,
      FlutterGradientNames.seaLord
    ].random();
    return FlutterGradients.findByName(name, tileMode: TileMode.clamp);
  }

  // ^ Palette Gradients ^ //
  static Gradient get Primary => _bottomUp([SonrColor.fromHex("#4aaaff"), SonrColor.fromHex("#1792ff")]);
  static Gradient get Secondary => _bottomUp([SonrColor.fromHex("#7f30ff"), SonrColor.fromHex("#9757ff")]);
  static Gradient get Tertiary => _bottomUp([SonrColor.fromHex("#17ffab"), SonrColor.fromHex("#52ffc0")]);
  static Gradient get Neutral => _bottomUp([SonrColor.fromHex("#a2a2a2"), SonrColor.fromHex("#a2a2a2")]);
  static Gradient get Critical => _bottomUp([SonrColor.fromHex('#ff176b'), SonrColor.fromHex('#ff176b', opacity: 0.7)]);
}

class SonrGradients {
  SonrGradients._();
  // * Constructer * //
  static LinearGradient _angle(double angle, List<Color> colors, List<double> stops) =>
      LinearGradient(colors: colors, stops: stops, transform: GradientRotation(radians(angle)), tileMode: TileMode.clamp);

  // ^ Accent Gradients ^ //
  /// [AmyCrisp] =  **Soft Blue**, **Soft Orange** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/014%20Amy%20Crisp.png)
  static Gradient get AmyCrisp => _angle(
        30.0,
        [SonrColor.fromHex("#a6c0fe"), SonrColor.fromHex("#f68084")],
        [0.0, 1.0],
      );

  /// [AmourAmour] =  **Soft Orange**, **Soft Pink** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/097%20Amour%20Amour.png)
  static Gradient get AmourAmour => _angle(
        -90.0,
        [SonrColor.fromHex("#f77062"), SonrColor.fromHex("#fe5196")],
        [0.0, 1.0],
      );

  /// [CrystalRiver] =  **LightBlue**, **Blue**, **Purple** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/159%20Crystal%20River.png)
  static Gradient get CrystalRiver => _angle(
        -315.0,
        [SonrColor.fromHex("#22E1FF"), SonrColor.fromHex("#1D8FE1"), SonrColor.fromHex("#625EB1")],
        [0.0, 0.48, 1.0],
      );

  /// [FabledSunset] =  **Deep Purple**, **Purple**, **Red**, **Yellow** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/179%20Fabled%20Sunset.png)
  static Gradient get FabledSunset => _angle(
        -315.0,
        [SonrColor.fromHex("#231557"), SonrColor.fromHex("#44107A"), SonrColor.fromHex("#FF1361"), SonrColor.fromHex("#FFF800")],
        [0.0, 0.29, 0.67, 1.0],
      );

  /// [FarawayRiver] =  **Purple**, **Blue**,  @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/086%20Faraway%20River.png)
  static Gradient get FarawayRiver => _angle(
        -110.0,
        [SonrColor.fromHex("#6e45e2"), SonrColor.fromHex("#88d3ce")],
        [0.0, 1.0],
      );

  /// [FlyingLemon] =  **Blue**, **Green**,  @ -30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/113%20Flying%20Lemon.png)
  static Gradient get FlyingLemon => _angle(
        -30.0,
        [SonrColor.fromHex("#64b3f4"), SonrColor.fromHex("#c2e59c")],
        [0.0, 1.0],
      );

  /// [FrozenHeat] =  **Pink**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/177%20Frozen%20Heat.png)
  static Gradient get FrozenHeat => _angle(
        -315.0,
        [SonrColor.fromHex("#FF057C"), SonrColor.fromHex("#7C64D5"), SonrColor.fromHex("#4CC3FF")],
        [0.0, 0.48, 1.0],
      );

  /// [ItmeoBranding] =  **Green**, **Blue**,  @ 90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/035%20Itmeo%20Branding.png)
  static Gradient get ItmeoBranding => _angle(
        90.0,
        [SonrColor.fromHex("#2af598"), SonrColor.fromHex("#009efd")],
        [0.0, 1.0],
      );

  /// [JapanBlush] =  **Light Purple**, **Salmon** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/092%20Japan%20Blush.png)
  static Gradient get JapanBlush => _angle(
        -110.0,
        [SonrColor.fromHex("#ddd6f3"), SonrColor.fromHex("#faaca8")],
        [0.0, 1.0],
      );

  /// [JuicyCake] =  **Pink**, **Yellow** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/146%20Juicy%20Cake.png)
  static Gradient get JuicyCake => _angle(
        -90.0,
        [SonrColor.fromHex("#e14fad"), SonrColor.fromHex("#f9d423")],
        [0.0, 1.0],
      );

  /// [Lollipop] =  **Purple**, **Maroon**, **Red** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/173%20Sugar%20Lollipop.png)
  static Gradient get Lollipop => _angle(
        -315.0,
        [SonrColor.fromHex("#A445B2"), SonrColor.fromHex("#D41872"), SonrColor.fromHex("#FF0066")],
        [0.0, 0.52, 1.0],
      );

  /// [LoveKiss] =  **Red**, **Salmon** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/073%20Love%20Kiss.png)
  static Gradient get LoveKiss => _angle(
        90.0,
        [SonrColor.fromHex("#ff0844"), SonrColor.fromHex("#ffb199")],
        [0.0, 1.0],
      );

  /// [MalibuBeach] =  **Blue**, **Aqua** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/019%20Malibu%20Beach.png)
  static Gradient get MalibuBeach => _angle(
        0.0,
        [SonrColor.fromHex("#4facfe"), SonrColor.fromHex("#00f2fe")],
        [0.0, 1.0],
      );

  /// [NightCall] =  **Light Purple**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/168%20Night%20Call.png)
  static Gradient get NightCall => _angle(
        -315.0,
        [SonrColor.fromHex("#AC32E4"), SonrColor.fromHex("#7918F2"), SonrColor.fromHex("#4801FF")],
        [0.0, 0.48, 1.0],
      );

  /// [NorseBeauty] =  **Salmon**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/149%20Norse%20Beauty.png)
  static Gradient get NorseBeauty => _angle(
        0.0,
        [SonrColor.fromHex("#ec77ab"), SonrColor.fromHex("#7873f5")],
        [0.0, 1.0],
      );

  /// [NorthMiracle] =  **Blue**, **Purple** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/136%20North%20Miracle.png)
  static Gradient get NorthMiracle => _angle(
        0.0,
        [SonrColor.fromHex("#00dbde"), SonrColor.fromHex("#fc00ff")],
        [0.0, 1.0],
      );

  /// [OctoberSilence] =  **Purple**, **Blue** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/085%20October%20Silence.png)
  static Gradient get OctoberSilence => _angle(
        -110.0,
        [SonrColor.fromHex("#b721ff"), SonrColor.fromHex("#21d4fd")],
        [0.0, 1.0],
      );

  /// [OrangeJuice] =  **Redish**, **Orange** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/133%20Orange%20Juice.png)
  static Gradient get OrangeJuice => _angle(
        -110.0,
        [SonrColor.fromHex("#fc6076"), SonrColor.fromHex("#ff9a44")],
        [0.0, 1.0],
      );

  /// [PerfectBlue] =  **DarkBlue**, **Blue**, **LightBlue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/180%20Perfect%20Blue.png)
  static Gradient get PerfectBlue => _angle(
        -315.0,
        [SonrColor.fromHex("#3D4E81"), SonrColor.fromHex("#5753C9"), SonrColor.fromHex("#6E7FF3")],
        [0.0, 0.48, 1.0],
      );

  /// [PhoenixStart] =  **Deep Orange**, **Yellow** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/084%20Phoenix%20Start.png)
  static Gradient get PhoenixStart => _angle(
        0.0,
        [SonrColor.fromHex("#f83600"), SonrColor.fromHex("#f9d423")],
        [0.0, 1.0],
      );

  /// [PlumBath] =  **Pink**, **Purple** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/128%20Plum%20Bath.png)
  static Gradient get PlumBath => _angle(
        -90.0,
        [SonrColor.fromHex("#cc208e"), SonrColor.fromHex("#6713d2")],
        [0.0, 1.0],
      );

  /// [PremiumDark] =  **Grey**, **Black** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/076%20Premium%20Dark.png)
  static Gradient get PremiumDark => _angle(
        0.0,
        [SonrColor.fromHex("#434343"), Colors.black],
        [0.0, 1.0],
      );

  /// [PremiumWhite] =  **Grey**, **White** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/089%20Premium%20White.png)
  static Gradient get PremiumWhite => _angle(
        -90.0,
        [
          SonrColor.fromHex("#d5d4d0"),
          SonrColor.fromHex("#d5d4d0"),
          SonrColor.fromHex("#eeeeec"),
          SonrColor.fromHex("#efeeec"),
          SonrColor.fromHex("#e9e9e7"),
        ],
        [0.0, 0.01, 0.31, 0.75, 1.0],
      );

  /// [RoyalGarden] =  **Light Pink**, **Orange** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/144%20Royal%20Garden.png)
  static Gradient get RoyalGarden => _angle(
        0.0,
        [SonrColor.fromHex("#ed6ea0"), SonrColor.fromHex("#ec8c69")],
        [0.0, 1.0],
      );

  /// [SeaLord] =  **Aqua**, **Purple-Blue**, **Soft Pink** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/152%20Sea%20Lord.png)
  static Gradient get SeaLord => _angle(
        -315.0,
        [SonrColor.fromHex("#2CD8D5"), SonrColor.fromHex("#C5C1FF"), SonrColor.fromHex("#FFBAC3")],
        [0.0, 0.56, 1.0],
      );

  /// [SeaShore] =  **Blue**, **Green** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/120%20Seashore.png)
  static Gradient get SeaShore => _angle(
        -90.0,
        [SonrColor.fromHex("#209cff"), SonrColor.fromHex("#68e0cf")],
        [0.0, 1.0],
      );

  /// [SolidStone] =  **Dark Navy**, **Grey Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/132%20Solid%20Stone.png)
  static Gradient get SolidStone => _angle(
        0.0,
        [SonrColor.fromHex("#243949"), SonrColor.fromHex("#517fa4")],
        [0.0, 1.0],
      );

  /// [SummerGames] =  **Green**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/079%20Summer%20Games.png)
  static Gradient get SummerGames => _angle(
        0.0,
        [SonrColor.fromHex("#92fe9d"), SonrColor.fromHex("#00c9ff")],
        [0.0, 1.0],
      );

  /// [SunnyMorning] =  **Yellow**, **Peach** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/007%20Sunny%20Morning.png)
  static Gradient get SunnyMorning => _angle(
        30.0,
        [SonrColor.fromHex("#f6d365"), SonrColor.fromHex("#fda085")],
        [0.0, 1.0],
      );

  /// [SupremeSky] =  **Neutral Green**, **Bright Green**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/169%20Supreme%20Sky.png)
  static Gradient get SupremeSky => _angle(
        -315.0,
        [SonrColor.fromHex("#D4FFEC"), SonrColor.fromHex("#57F2CC"), SonrColor.fromHex("#4596FB")],
        [0.0, 0.48, 1.0],
      );
}
