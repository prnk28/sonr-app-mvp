import 'package:sonr_app/style/style.dart';

import 'package:flutter/material.dart';

class AppGradients {
  static Gradient Primary({double radius = 1.0}) => Get.isDarkMode
      ? CGUtility.angledFrom(
          angle: AppGradientColor.K_PRIMARY_ANGLE,
          values: [
            AppGradientColor.primaryStart(Get.isDarkMode),
            AppGradientColor.primaryEnd(Get.isDarkMode),
          ],
        )
      : RadialGradient(
          radius: radius,
          colors: AppGradientColor.lightColors.item1,
          center: AppGradientColor.lightAlignment.item1,
          focal: AppGradientColor.lightAlignment.item2,
          stops: AppGradientColor.lightColors.item2,
        );

  static Gradient get Foreground => CGUtility.angledFrom(
        angle: AppGradientColor.K_FOREGROUND_ANGLE,
        values: [
          AppGradientColor.foregroundStart(Get.isDarkMode),
          AppGradientColor.foregroundEnd(Get.isDarkMode),
        ],
      );
}

class DesignGradients {
  DesignGradients._();
  // * Constructer * //
  /// ## Accent Gradients
  /// [AmyCrisp] =  **Soft Blue**, **Soft Orange** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/014%20Amy%20Crisp.png)
  static Gradient get AmyCrisp => CGUtility.angled(
        30.0,
        [CGUtility.hex("#a6c0fe"), CGUtility.hex("#f68084")],
        [0.0, 1.0],
      );

  /// [AmourAmour] =  **Soft Orange**, **Soft Pink** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/097%20Amour%20Amour.png)
  static Gradient get AmourAmour => CGUtility.angled(
        -90.0,
        [CGUtility.hex("#f77062"), CGUtility.hex("#fe5196")],
        [0.0, 1.0],
      );

  /// [CrystalRiver] =  **LightBlue**, **Blue**, **Purple** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/159%20Crystal%20River.png)
  static Gradient get CrystalRiver => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#22E1FF"), CGUtility.hex("#1D8FE1"), CGUtility.hex("#625EB1")],
        [0.0, 0.48, 1.0],
      );

  /// [FabledSunset] =  **Deep Purple**, **Purple**, **Red**, **Yellow** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/179%20Fabled%20Sunset.png)
  static Gradient get FabledSunset => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#231557"), CGUtility.hex("#44107A"), CGUtility.hex("#FF1361"), CGUtility.hex("#FFF800")],
        [0.0, 0.29, 0.67, 1.0],
      );

  /// [FarawayRiver] =  **Purple**, **Blue**,  @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/086%20Faraway%20River.png)
  static Gradient get FarawayRiver => CGUtility.angled(
        -110.0,
        [CGUtility.hex("#6e45e2"), CGUtility.hex("#88d3ce")],
        [0.0, 1.0],
      );

  /// [FlyingLemon] =  **Blue**, **Green**,  @ -30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/113%20Flying%20Lemon.png)
  static Gradient get FlyingLemon => CGUtility.angled(
        -30.0,
        [CGUtility.hex("#64b3f4"), CGUtility.hex("#c2e59c")],
        [0.0, 1.0],
      );

  /// [FrozenHeat] =  **Pink**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/177%20Frozen%20Heat.png)
  static Gradient get FrozenHeat => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#FF057C"), CGUtility.hex("#7C64D5"), CGUtility.hex("#4CC3FF")],
        [0.0, 0.48, 1.0],
      );

  /// [ItmeoBranding] =  **Green**, **Blue**,  @ 90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/035%20Itmeo%20Branding.png)
  static Gradient get ItmeoBranding => CGUtility.angled(
        90.0,
        [CGUtility.hex("#2af598"), CGUtility.hex("#009efd")],
        [0.0, 1.0],
      );

  /// [JapanBlush] =  **Light Purple**, **Salmon** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/092%20Japan%20Blush.png)
  static Gradient get JapanBlush => CGUtility.angled(
        -110.0,
        [CGUtility.hex("#ddd6f3"), CGUtility.hex("#faaca8")],
        [0.0, 1.0],
      );

  /// [JuicyCake] =  **Pink**, **Yellow** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/146%20Juicy%20Cake.png)
  static Gradient get JuicyCake => CGUtility.angled(
        -90.0,
        [CGUtility.hex("#e14fad"), CGUtility.hex("#f9d423")],
        [0.0, 1.0],
      );

  /// [Lollipop] =  **Purple**, **Maroon**, **Red** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/173%20Sugar%20Lollipop.png)
  static Gradient get Lollipop => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#A445B2"), CGUtility.hex("#D41872"), CGUtility.hex("#FF0066")],
        [0.0, 0.52, 1.0],
      );

  /// [LoveKiss] =  **Red**, **Salmon** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/073%20Love%20Kiss.png)
  static Gradient get LoveKiss => CGUtility.angled(
        90.0,
        [CGUtility.hex("#ff0844"), CGUtility.hex("#ffb199")],
        [0.0, 1.0],
      );

  /// [MalibuBeach] =  **Blue**, **Aqua** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/019%20Malibu%20Beach.png)
  static Gradient get MalibuBeach => CGUtility.angled(
        0.0,
        [CGUtility.hex("#4facfe"), CGUtility.hex("#00f2fe")],
        [0.0, 1.0],
      );

  /// [NightCall] =  **Light Purple**, **Purple**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/168%20Night%20Call.png)
  static Gradient get NightCall => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#AC32E4"), CGUtility.hex("#7918F2"), CGUtility.hex("#4801FF")],
        [0.0, 0.48, 1.0],
      );

  /// [NorseBeauty] =  **Salmon**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/149%20Norse%20Beauty.png)
  static Gradient get NorseBeauty => CGUtility.angled(
        0.0,
        [CGUtility.hex("#ec77ab"), CGUtility.hex("#7873f5")],
        [0.0, 1.0],
      );

  /// [NorthMiracle] =  **Blue**, **Purple** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/136%20North%20Miracle.png)
  static Gradient get NorthMiracle => CGUtility.angled(
        0.0,
        [CGUtility.hex("#00dbde"), CGUtility.hex("#fc00ff")],
        [0.0, 1.0],
      );

  /// [OctoberSilence] =  **Purple**, **Blue** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/085%20October%20Silence.png)
  static Gradient get OctoberSilence => CGUtility.angled(
        -110.0,
        [CGUtility.hex("#b721ff"), CGUtility.hex("#21d4fd")],
        [0.0, 1.0],
      );

  /// [OrangeJuice] =  **Redish**, **Orange** @ -110.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/133%20Orange%20Juice.png)
  static Gradient get OrangeJuice => CGUtility.angled(
        -110.0,
        [CGUtility.hex("#fc6076"), CGUtility.hex("#ff9a44")],
        [0.0, 1.0],
      );

  /// [PerfectBlue] =  **DarkBlue**, **Blue**, **LightBlue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/180%20Perfect%20Blue.png)
  static Gradient get PerfectBlue => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#3D4E81"), CGUtility.hex("#5753C9"), CGUtility.hex("#6E7FF3")],
        [0.0, 0.48, 1.0],
      );

  /// [PhoenixStart] =  **Deep Orange**, **Yellow** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/084%20Phoenix%20Start.png)
  static Gradient get PhoenixStart => CGUtility.angled(
        0.0,
        [CGUtility.hex("#f83600"), CGUtility.hex("#f9d423")],
        [0.0, 1.0],
      );

  /// [PlumBath] =  **Pink**, **Purple** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/128%20Plum%20Bath.png)
  static Gradient get PlumBath => CGUtility.angled(
        -90.0,
        [CGUtility.hex("#cc208e"), CGUtility.hex("#6713d2")],
        [0.0, 1.0],
      );

  /// [PremiumDark] =  **Grey**, **Black** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/076%20Premium%20Dark.png)
  static Gradient get PremiumDark => CGUtility.angled(
        0.0,
        [CGUtility.hex("#434343"), Colors.black],
        [0.0, 1.0],
      );

  /// [PremiumWhite] =  **Grey**, **White** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/089%20Premium%20White.png)
  static Gradient get PremiumWhite => CGUtility.angled(
        -90.0,
        [
          CGUtility.hex("#d5d4d0"),
          CGUtility.hex("#d5d4d0"),
          CGUtility.hex("#eeeeec"),
          CGUtility.hex("#efeeec"),
          CGUtility.hex("#e9e9e7"),
        ],
        [0.0, 0.01, 0.31, 0.75, 1.0],
      );

  /// [RoyalGarden] =  **Light Pink**, **Orange** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/144%20Royal%20Garden.png)
  static Gradient get RoyalGarden => CGUtility.angled(
        0.0,
        [CGUtility.hex("#ed6ea0"), CGUtility.hex("#ec8c69")],
        [0.0, 1.0],
      );

  /// [SeaLord] =  **Aqua**, **Purple-Blue**, **Soft Pink** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/152%20Sea%20Lord.png)
  static Gradient get SeaLord => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#2CD8D5"), CGUtility.hex("#C5C1FF"), CGUtility.hex("#FFBAC3")],
        [0.0, 0.56, 1.0],
      );

  /// [SeaShore] =  **Blue**, **Green** @ -90.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/120%20Seashore.png)
  static Gradient get SeaShore => CGUtility.angled(
        -90.0,
        [CGUtility.hex("#209cff"), CGUtility.hex("#68e0cf")],
        [0.0, 1.0],
      );

  /// [SolidStone] =  **Dark Navy**, **Grey Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/132%20Solid%20Stone.png)
  static Gradient get SolidStone => CGUtility.angled(
        0.0,
        [CGUtility.hex("#243949"), CGUtility.hex("#517fa4")],
        [0.0, 1.0],
      );

  /// [SummerGames] =  **Green**, **Blue** @ 0.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/079%20Summer%20Games.png)
  static Gradient get SummerGames => CGUtility.angled(
        0.0,
        [CGUtility.hex("#92fe9d"), CGUtility.hex("#00c9ff")],
        [0.0, 1.0],
      );

  /// [SunnyMorning] =  **Yellow**, **Peach** @ 30.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/007%20Sunny%20Morning.png)
  static Gradient get SunnyMorning => CGUtility.angled(
        30.0,
        [CGUtility.hex("#f6d365"), CGUtility.hex("#fda085")],
        [0.0, 1.0],
      );

  /// [SupremeSky] =  **Neutral Green**, **Bright Green**, **Blue** @ -315.0°
  /// ![Preview](https://webgradients.com/public/webgradients_png/169%20Supreme%20Sky.png)
  static Gradient get SupremeSky => CGUtility.angled(
        -315.0,
        [CGUtility.hex("#D4FFEC"), CGUtility.hex("#57F2CC"), CGUtility.hex("#4596FB")],
        [0.0, 0.48, 1.0],
      );
}
