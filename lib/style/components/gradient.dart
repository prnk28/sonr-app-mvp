import 'dart:math';
import 'package:sonr_app/style/style.dart';

import 'package:flutter/material.dart';

class AppGradients {
  
  static LinearGradient get DarkCard => LinearGradient(
        colors: [Color(0xff2a2626), Color(0xff322d2d)],
        stops: [0, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get LightCard => LinearGradient(
        colors: [Color(0xffd8dde1), Color(0xffffffff)],
        stops: [0, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// ## Generates Random Gradient for Progress View
  static Gradient get Progress {
    final rand = Random();
    var list = <Gradient>[
      DesignGradients.AmyCrisp,
      DesignGradients.Lollipop,
      DesignGradients.SummerGames,
      DesignGradients.SupremeSky,
      DesignGradients.JuicyCake,
      DesignGradients.NorthMiracle,
      DesignGradients.SeaLord,
    ];
    return list[rand.nextInt(list.length)];
  }

  /// ## Palette Gradients
  // static Gradient get Primary => _bottomUp([SonrColor.fromHex("#4aaaff"), SonrColor.fromHex("#1792ff")]);
  // static Gradient get Secondary => _bottomUp([SonrColor.fromHex("#7f30ff"), SonrColor.fromHex("#9757ff")]);
  // static Gradient get Tertiary => _bottomUp([SonrColor.fromHex("#00FA9A"), SonrColor.fromHex("#00c87b")]);
  // static Gradient get Neutral => _bottomUp([SonrColor.fromHex("#a2a2a2"), SonrColor.fromHex("#a2a2a2")]);
  // static Gradient get Critical => _bottomUp([SonrColor.fromHex('#ff176b'), SonrColor.fromHex('#ff176b', opacity: 0.7)]);

  /// Returns Theme Gradient
  static Gradient Theme({double radius = 0.72}) {
    final lightColors = [
      Color(0xffFFCF14),
      Color(0xffF3ACFF),
      Color(0xff8AECFF),
    ];
    final darkColors = [
      Color(0xffFFCF14),
      Color(0xffEE8FFF),
      Color(0xff38DEFF),
    ];
    return RadialGradient(
      colors: Get.isDarkMode ? darkColors : lightColors,
      stops: [0, 0.45, 1],
      center: Alignment.center,
      focal: Alignment.topRight,
      tileMode: TileMode.clamp,
      radius: radius,
    );
  }
}

class DesignGradients {
  DesignGradients._();
  // * Constructer * //
  /// ## Accent Gradients
  /// [AmyCrisp] =  **Soft Blue**, **Soft Orange** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/014%20Amy%20Crisp.png)
  static Gradient get AmyCrisp => CGUtility.angledGradient(
        30.0,
        [CGUtility.hexColor("#a6c0fe"), CGUtility.hexColor("#f68084")],
        [0.0, 1.0],
      );

  /// [AmourAmour] =  **Soft Orange**, **Soft Pink** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/097%20Amour%20Amour.png)
  static Gradient get AmourAmour => CGUtility.angledGradient(
        -90.0,
        [CGUtility.hexColor("#f77062"), CGUtility.hexColor("#fe5196")],
        [0.0, 1.0],
      );

  /// [CrystalRiver] =  **LightBlue**, **Blue**, **Purple** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/159%20Crystal%20River.png)
  static Gradient get CrystalRiver => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#22E1FF"), CGUtility.hexColor("#1D8FE1"), CGUtility.hexColor("#625EB1")],
        [0.0, 0.48, 1.0],
      );

  /// [FabledSunset] =  **Deep Purple**, **Purple**, **Red**, **Yellow** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/179%20Fabled%20Sunset.png)
  static Gradient get FabledSunset => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#231557"), CGUtility.hexColor("#44107A"), CGUtility.hexColor("#FF1361"), CGUtility.hexColor("#FFF800")],
        [0.0, 0.29, 0.67, 1.0],
      );

  /// [FarawayRiver] =  **Purple**, **Blue**,  @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/086%20Faraway%20River.png)
  static Gradient get FarawayRiver => CGUtility.angledGradient(
        -110.0,
        [CGUtility.hexColor("#6e45e2"), CGUtility.hexColor("#88d3ce")],
        [0.0, 1.0],
      );

  /// [FlyingLemon] =  **Blue**, **Green**,  @ -30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/113%20Flying%20Lemon.png)
  static Gradient get FlyingLemon => CGUtility.angledGradient(
        -30.0,
        [CGUtility.hexColor("#64b3f4"), CGUtility.hexColor("#c2e59c")],
        [0.0, 1.0],
      );

  /// [FrozenHeat] =  **Pink**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/177%20Frozen%20Heat.png)
  static Gradient get FrozenHeat => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#FF057C"), CGUtility.hexColor("#7C64D5"), CGUtility.hexColor("#4CC3FF")],
        [0.0, 0.48, 1.0],
      );

  /// [ItmeoBranding] =  **Green**, **Blue**,  @ 90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/035%20Itmeo%20Branding.png)
  static Gradient get ItmeoBranding => CGUtility.angledGradient(
        90.0,
        [CGUtility.hexColor("#2af598"), CGUtility.hexColor("#009efd")],
        [0.0, 1.0],
      );

  /// [JapanBlush] =  **Light Purple**, **Salmon** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/092%20Japan%20Blush.png)
  static Gradient get JapanBlush => CGUtility.angledGradient(
        -110.0,
        [CGUtility.hexColor("#ddd6f3"), CGUtility.hexColor("#faaca8")],
        [0.0, 1.0],
      );

  /// [JuicyCake] =  **Pink**, **Yellow** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/146%20Juicy%20Cake.png)
  static Gradient get JuicyCake => CGUtility.angledGradient(
        -90.0,
        [CGUtility.hexColor("#e14fad"), CGUtility.hexColor("#f9d423")],
        [0.0, 1.0],
      );

  /// [Lollipop] =  **Purple**, **Maroon**, **Red** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/173%20Sugar%20Lollipop.png)
  static Gradient get Lollipop => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#A445B2"), CGUtility.hexColor("#D41872"), CGUtility.hexColor("#FF0066")],
        [0.0, 0.52, 1.0],
      );

  /// [LoveKiss] =  **Red**, **Salmon** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/073%20Love%20Kiss.png)
  static Gradient get LoveKiss => CGUtility.angledGradient(
        90.0,
        [CGUtility.hexColor("#ff0844"), CGUtility.hexColor("#ffb199")],
        [0.0, 1.0],
      );

  /// [MalibuBeach] =  **Blue**, **Aqua** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/019%20Malibu%20Beach.png)
  static Gradient get MalibuBeach => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#4facfe"), CGUtility.hexColor("#00f2fe")],
        [0.0, 1.0],
      );

  /// [NightCall] =  **Light Purple**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/168%20Night%20Call.png)
  static Gradient get NightCall => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#AC32E4"), CGUtility.hexColor("#7918F2"), CGUtility.hexColor("#4801FF")],
        [0.0, 0.48, 1.0],
      );

  /// [NorseBeauty] =  **Salmon**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/149%20Norse%20Beauty.png)
  static Gradient get NorseBeauty => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#ec77ab"), CGUtility.hexColor("#7873f5")],
        [0.0, 1.0],
      );

  /// [NorthMiracle] =  **Blue**, **Purple** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/136%20North%20Miracle.png)
  static Gradient get NorthMiracle => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#00dbde"), CGUtility.hexColor("#fc00ff")],
        [0.0, 1.0],
      );

  /// [OctoberSilence] =  **Purple**, **Blue** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/085%20October%20Silence.png)
  static Gradient get OctoberSilence => CGUtility.angledGradient(
        -110.0,
        [CGUtility.hexColor("#b721ff"), CGUtility.hexColor("#21d4fd")],
        [0.0, 1.0],
      );

  /// [OrangeJuice] =  **Redish**, **Orange** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/133%20Orange%20Juice.png)
  static Gradient get OrangeJuice => CGUtility.angledGradient(
        -110.0,
        [CGUtility.hexColor("#fc6076"), CGUtility.hexColor("#ff9a44")],
        [0.0, 1.0],
      );

  /// [PerfectBlue] =  **DarkBlue**, **Blue**, **LightBlue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/180%20Perfect%20Blue.png)
  static Gradient get PerfectBlue => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#3D4E81"), CGUtility.hexColor("#5753C9"), CGUtility.hexColor("#6E7FF3")],
        [0.0, 0.48, 1.0],
      );

  /// [PhoenixStart] =  **Deep Orange**, **Yellow** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/084%20Phoenix%20Start.png)
  static Gradient get PhoenixStart => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#f83600"), CGUtility.hexColor("#f9d423")],
        [0.0, 1.0],
      );

  /// [PlumBath] =  **Pink**, **Purple** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/128%20Plum%20Bath.png)
  static Gradient get PlumBath => CGUtility.angledGradient(
        -90.0,
        [CGUtility.hexColor("#cc208e"), CGUtility.hexColor("#6713d2")],
        [0.0, 1.0],
      );

  /// [PremiumDark] =  **Grey**, **Black** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/076%20Premium%20Dark.png)
  static Gradient get PremiumDark => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#434343"), Colors.black],
        [0.0, 1.0],
      );

  /// [PremiumWhite] =  **Grey**, **White** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/089%20Premium%20White.png)
  static Gradient get PremiumWhite => CGUtility.angledGradient(
        -90.0,
        [
          CGUtility.hexColor("#d5d4d0"),
          CGUtility.hexColor("#d5d4d0"),
          CGUtility.hexColor("#eeeeec"),
          CGUtility.hexColor("#efeeec"),
          CGUtility.hexColor("#e9e9e7"),
        ],
        [0.0, 0.01, 0.31, 0.75, 1.0],
      );

  /// [RoyalGarden] =  **Light Pink**, **Orange** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/144%20Royal%20Garden.png)
  static Gradient get RoyalGarden => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#ed6ea0"), CGUtility.hexColor("#ec8c69")],
        [0.0, 1.0],
      );

  /// [SeaLord] =  **Aqua**, **Purple-Blue**, **Soft Pink** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/152%20Sea%20Lord.png)
  static Gradient get SeaLord => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#2CD8D5"), CGUtility.hexColor("#C5C1FF"), CGUtility.hexColor("#FFBAC3")],
        [0.0, 0.56, 1.0],
      );

  /// [SeaShore] =  **Blue**, **Green** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/120%20Seashore.png)
  static Gradient get SeaShore => CGUtility.angledGradient(
        -90.0,
        [CGUtility.hexColor("#209cff"), CGUtility.hexColor("#68e0cf")],
        [0.0, 1.0],
      );

  /// [SolidStone] =  **Dark Navy**, **Grey Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/132%20Solid%20Stone.png)
  static Gradient get SolidStone => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#243949"), CGUtility.hexColor("#517fa4")],
        [0.0, 1.0],
      );

  /// [SummerGames] =  **Green**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/079%20Summer%20Games.png)
  static Gradient get SummerGames => CGUtility.angledGradient(
        0.0,
        [CGUtility.hexColor("#92fe9d"), CGUtility.hexColor("#00c9ff")],
        [0.0, 1.0],
      );

  /// [SunnyMorning] =  **Yellow**, **Peach** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/007%20Sunny%20Morning.png)
  static Gradient get SunnyMorning => CGUtility.angledGradient(
        30.0,
        [CGUtility.hexColor("#f6d365"), CGUtility.hexColor("#fda085")],
        [0.0, 1.0],
      );

  /// [SupremeSky] =  **Neutral Green**, **Bright Green**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/169%20Supreme%20Sky.png)
  static Gradient get SupremeSky => CGUtility.angledGradient(
        -315.0,
        [CGUtility.hexColor("#D4FFEC"), CGUtility.hexColor("#57F2CC"), CGUtility.hexColor("#4596FB")],
        [0.0, 0.48, 1.0],
      );
}
