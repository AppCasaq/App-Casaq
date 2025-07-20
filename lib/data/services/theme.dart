import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF217DD6),
      surfaceTint: Color(0xff3b608f),
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      primaryContainer: Color(0xFFBBDEF0),
      onPrimaryContainer: Color(0xff001c39),
      secondary: Color(0xFF122F89),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xFFBBDEF0),
      onSecondaryContainer: Color(0xff06164b),
      tertiary: Color(0xFF101935),
      onTertiary: Color.fromARGB(255, 255, 255, 255),
      tertiaryContainer: Color(0xffdce1ff),
      onTertiaryContainer: Color(0xff02174b),
      error: Color.fromARGB(255, 214, 80, 68),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad5),
      onErrorContainer: Color(0xff3b0907),
      background: Color.fromARGB(255, 255, 255, 255),
      onBackground: Color(0xff191c20),
      surface: Color.fromARGB(255, 255, 255, 255),
      onSurface: Color(0xff171d1e),
      surfaceVariant: Color.fromARGB(255, 255, 255, 255),
      onSurfaceVariant: Color(0xff40484c),
      outline: Color(0xff70787d),
      outlineVariant: Color(0xffc0c8cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffecf2f3),
      inversePrimary: Color(0xffa4c9fe),
      primaryFixed: Color(0xffd4e3ff),
      onPrimaryFixed: Color(0xff001c39),
      primaryFixedDim: Color(0xffa4c9fe),
      onPrimaryFixedVariant: Color(0xff204876),
      secondaryFixed: Color(0xffdde1ff),
      onSecondaryFixed: Color(0xff06164b),
      secondaryFixedDim: Color(0xffb7c4ff),
      onSecondaryFixedVariant: Color(0xff364379),
      tertiaryFixed: Color(0xffdce1ff),
      onTertiaryFixed: Color(0xff02174b),
      tertiaryFixedDim: Color(0xffb5c4ff),
      onTertiaryFixedVariant: Color(0xff344479),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff1b4472),
      surfaceTint: Color(0xff3b608f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5276a7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff323f74),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6572aa),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff304074),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6272aa),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6e302a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffaa6057),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff8f9ff),
      onBackground: Color(0xff191c20),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff171d1e),
      surfaceVariant: Color(0xffdce4e9),
      onSurfaceVariant: Color(0xff3c4448),
      outline: Color(0xff586065),
      outlineVariant: Color(0xff747c80),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffecf2f3),
      inversePrimary: Color(0xffa4c9fe),
      primaryFixed: Color(0xff5276a7),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff385d8d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6572aa),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c5990),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6272aa),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff495a8f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff002344),
      surfaceTint: Color(0xff3b608f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1b4472),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0f1e52),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff323f74),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0a1e52),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff304074),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff44100c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff6e302a),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfff8f9ff),
      onBackground: Color(0xff191c20),
      surface: Color(0xfff5fafb),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffdce4e9),
      onSurfaceVariant: Color(0xff1d2529),
      outline: Color(0xff3c4448),
      outlineVariant: Color(0xff3c4448),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3133),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffe3ecff),
      primaryFixed: Color(0xff1b4472),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002d56),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff323f74),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1b295d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff304074),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff18295d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbdc),
      surfaceBright: Color(0xfff5fafb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f6),
      surfaceContainer: Color(0xffe9eff0),
      surfaceContainerHigh: Color(0xffe3e9ea),
      surfaceContainerHighest: Color(0xffdee3e5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa4c9fe),
      surfaceTint: Color(0xffa4c9fe),
      onPrimary: Color(0xff00315d),
      primaryContainer: Color(0xff204876),
      onPrimaryContainer: Color(0xffd4e3ff),
      secondary: Color(0xffb7c4ff),
      onSecondary: Color(0xff1f2d61),
      secondaryContainer: Color(0xff364379),
      onSecondaryContainer: Color(0xffdde1ff),
      tertiary: Color(0xffb5c4ff),
      onTertiary: Color(0xff1c2d61),
      tertiaryContainer: Color(0xff344479),
      onTertiaryContainer: Color(0xffdce1ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff561e19),
      errorContainer: Color(0xff73342d),
      onErrorContainer: Color(0xffffdad5),
      background: Color(0xff111318),
      onBackground: Color(0xffe1e2e9),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdee3e5),
      surfaceVariant: Color(0xff40484c),
      onSurfaceVariant: Color(0xffc0c8cd),
      outline: Color(0xff8a9297),
      outlineVariant: Color(0xff40484c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff2b3133),
      inversePrimary: Color(0xff3b608f),
      primaryFixed: Color(0xffd4e3ff),
      onPrimaryFixed: Color(0xff001c39),
      primaryFixedDim: Color(0xffa4c9fe),
      onPrimaryFixedVariant: Color(0xff204876),
      secondaryFixed: Color(0xffdde1ff),
      onSecondaryFixed: Color(0xff06164b),
      secondaryFixedDim: Color(0xffb7c4ff),
      onSecondaryFixedVariant: Color(0xff364379),
      tertiaryFixed: Color(0xffdce1ff),
      onTertiaryFixed: Color(0xff02174b),
      tertiaryFixedDim: Color(0xffb5c4ff),
      onTertiaryFixedVariant: Color(0xff344479),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffabcdff),
      surfaceTint: Color(0xffa4c9fe),
      onPrimary: Color(0xff001730),
      primaryContainer: Color(0xff6e93c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbdc8ff),
      onSecondary: Color(0xff001046),
      secondaryContainer: Color(0xff818ec8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffbbc9ff),
      onTertiary: Color(0xff001242),
      tertiaryContainer: Color(0xff7e8ec8),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff330403),
      errorContainer: Color(0xffcc7b72),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff111318),
      onBackground: Color(0xffe1e2e9),
      surface: Color(0xff0e1415),
      onSurface: Color(0xfff6fcfd),
      surfaceVariant: Color(0xff40484c),
      onSurfaceVariant: Color(0xffc4ccd1),
      outline: Color(0xff9ca4a9),
      outlineVariant: Color(0xff7c8489),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff252b2c),
      inversePrimary: Color(0xff214977),
      primaryFixed: Color(0xffd4e3ff),
      onPrimaryFixed: Color(0xff001127),
      primaryFixedDim: Color(0xffa4c9fe),
      onPrimaryFixedVariant: Color(0xff063764),
      secondaryFixed: Color(0xffdde1ff),
      onSecondaryFixed: Color(0xff000c3a),
      secondaryFixedDim: Color(0xffb7c4ff),
      onSecondaryFixedVariant: Color(0xff253367),
      tertiaryFixed: Color(0xffdce1ff),
      onTertiaryFixed: Color(0xff000d36),
      tertiaryFixedDim: Color(0xffb5c4ff),
      onTertiaryFixedVariant: Color(0xff223367),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffbfaff),
      surfaceTint: Color(0xffa4c9fe),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffabcdff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbdc8ff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcfaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbbc9ff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff111318),
      onBackground: Color(0xffe1e2e9),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff40484c),
      onSurfaceVariant: Color(0xfff7fbff),
      outline: Color(0xffc4ccd1),
      outlineVariant: Color(0xffc4ccd1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e5),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff002b52),
      primaryFixed: Color(0xffdbe7ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffabcdff),
      onPrimaryFixedVariant: Color(0xff001730),
      secondaryFixed: Color(0xffe2e5ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbdc8ff),
      onSecondaryFixedVariant: Color(0xff001046),
      tertiaryFixed: Color(0xffe1e6ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffbbc9ff),
      onTertiaryFixedVariant: Color(0xff001242),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff171d1e),
      surfaceContainer: Color(0xff1b2122),
      surfaceContainerHigh: Color(0xff252b2c),
      surfaceContainerHighest: Color(0xff303637),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
