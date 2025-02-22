import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.1.1.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      // Custom colors
      primary: Color(0xFF4CAF50),
      primaryContainer: Color(0xFFC8FFC0),
      primaryLightRef: Color(0xFF4CAF50),
      secondary: Color(0xFF2196F3),
      secondaryContainer: Color(0xFFD1E4FF),
      secondaryLightRef: Color(0xFF2196F3),
      tertiary: Color(0xFFFFEB3B),
      tertiaryContainer: Color(0xFFFFFBFF),
      tertiaryLightRef: Color(0xFFFFEB3B),
      appBarColor: Color(0xFFD1E4FF),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFF8F7),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 10.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBackgroundAlpha: 80,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onPrimary,
      tooltipOpacity: null,
      dialogBackgroundSchemeColor: SchemeColor.onPrimary,
      snackBarBackgroundSchemeColor: SchemeColor.onPrimary,
      searchUseGlobalShape: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      // Custom colors
      primary: Color(0xFF9FC9FF),
      primaryContainer: Color(0xFF00325B),
      primaryLightRef: Color(0xFF4CAF50),
      secondary: Color(0xFFFFB59D),
      secondaryContainer: Color(0xFF872100),
      secondaryLightRef: Color(0xFF2196F3),
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF004E59),
      tertiaryLightRef: Color(0xFFFFEB3B),
      appBarColor: Color(0xFFD1E4FF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 10.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onPrimary,
      tooltipOpacity: null,
      snackBarBackgroundSchemeColor: SchemeColor.onPrimary,
      searchUseGlobalShape: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    useMaterial3ErrorColors: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

/*{
    "playground_data": "Themes Playground data exported 22.02.2025 22:10:48",
    "playground_version": "8.1.1",
    "blendLevelDark": 0,
    "blendLevelLight": 0,
    "blendLightOnColors": false,
    "blendOnLevelDark": 0,
    "blendOnLevelLight": 0,
    "customErrorContainerLight": {
        "dart_type": "color",
        "value": "FFFFF8F7"
    },
    "customPrimaryContainerLight": {
        "dart_type": "color",
        "value": "FFC8FFC0"
    },
    "customPrimaryDarkRef": {
        "dart_type": "color",
        "value": "FF4CAF50"
    },
    "customPrimaryLight": {
        "dart_type": "color",
        "value": "FF4CAF50"
    },
    "customPrimaryLightRef": {
        "dart_type": "color",
        "value": "FF4CAF50"
    },
    "customSecondaryContainerLight": {
        "dart_type": "color",
        "value": "FFD1E4FF"
    },
    "customSecondaryDarkRef": {
        "dart_type": "color",
        "value": "FF2196F3"
    },
    "customSecondaryLight": {
        "dart_type": "color",
        "value": "FF2196F3"
    },
    "customSecondaryLightRef": {
        "dart_type": "color",
        "value": "FF2196F3"
    },
    "customTertiaryContainerLight": {
        "dart_type": "color",
        "value": "FFFFFBFF"
    },
    "customTertiaryDarkRef": {
        "dart_type": "color",
        "value": "FFFFEB3B"
    },
    "customTertiaryLight": {
        "dart_type": "color",
        "value": "FFFFEB3B"
    },
    "customTertiaryLightRef": {
        "dart_type": "color",
        "value": "FFFFEB3B"
    },
    "defaultRadius": 10,
    "dialogBackgroundLightSchemeColor": {
        "dart_type": "enum_scheme_color",
        "value": "onPrimary"
    },
    "inputDecoratorBackgroundAlphaLight": 80,
    "inputDecoratorFocusedHasBorder": false,
    "inputDecoratorUnfocusedHasBorder": false,
    "keepDarkPrimary": false,
    "keepPrimary": false,
    "keepTertiary": false,
    "scaffoldLightIsWhite": false,
    "schemeIndex": 58,
    "searchUseGlobalShape": true,
    "showSchemeInputColors": true,
    "simulatorComponentsIndex": 1,
    "sliderValueTinted": false,
    "snackBarSchemeColor": {
        "dart_type": "enum_scheme_color",
        "value": "onPrimary"
    },
    "surfaceModeDark": {
        "dart_type": "enum_flex_surface_mode",
        "value": "level"
    },
    "surfaceModeLight": {
        "dart_type": "enum_flex_surface_mode",
        "value": "level"
    },
    "swapLegacyColorsInM3": false,
    "swapPrimaryAndSecondaryLightColors": false,
    "systemNavBarStyle": {
        "dart_type": "enum_flex_system_navbar_style",
        "value": "transparent"
    },
    "themeMode": {
        "dart_type": "enum_theme_mode",
        "value": "system"
    },
    "toDarkMethodLevel": 10,
    "toDarkSwapPrimaryAndContainer": true,
    "tooltipSchemeColor": {
        "dart_type": "enum_scheme_color",
        "value": "onPrimary"
    },
    "tooltipsMatchBackground": false,
    "topicIndexEndSide": 3,
    "topicIndexStartSide": 4,
    "unselectedToggleIsColored": false,
    "useError": false,
    "useKeyColors": false,
    "useM3ErrorColors": true,
    "useMaterial3Typography": true,
    "useSecondary": false,
    "useTertiary": false,
    "useToDarkMethod": false,
    "usedColors": 6,
    "usedFlexToneSetup": 0
}*/
