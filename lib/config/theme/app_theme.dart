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
    lightIsWhite: true,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      scaffoldBackgroundSchemeColor: SchemeColor.surfaceContainerHigh,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 10.0,
      switchAdaptiveCupertinoLike: FlexAdaptive.all(),
      sliderTrackHeight: 6,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 140,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      fabUseShape: true,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onPrimary,
      tooltipOpacity: null,
      dialogBackgroundSchemeColor: SchemeColor.onPrimary,
      snackBarBackgroundSchemeColor: SchemeColor.onPrimary,
      tabBarDividerColor: Color(0x00000000),
      tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
      menuBarShadowColor: Color(0x00000000),
      searchUseGlobalShape: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
      cardRadius: 0,
      cardElevation: 0,
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
      switchAdaptiveCupertinoLike: FlexAdaptive.all(),
      sliderTrackHeight: 6,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      fabUseShape: true,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onPrimary,
      tooltipOpacity: null,
      snackBarBackgroundSchemeColor: SchemeColor.onPrimary,
      tabBarDividerColor: Color(0x00000000),
      tabBarIndicatorAnimation: TabIndicatorAnimation.linear,
      menuBarShadowColor: Color(0x00000000),
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
    "playground_data": "Themes Playground data exported 04.03.2025 16:20:36",
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
    "floatingActionButtonAlwaysCircular": false,
    "floatingActionButtonUseShape": true,
    "inputDecoratorBackgroundAlphaLight": 140,
    "inputDecoratorFocusedHasBorder": false,
    "inputDecoratorIsDense": true,
    "inputDecoratorUnfocusedHasBorder": false,
    "keepDarkPrimary": false,
    "keepPrimary": false,
    "keepTertiary": false,
    "menuBarShadowColor": {
        "dart_type": "color",
        "value": "00000000"
    },
    "scaffoldBackgroundLightSchemeColor": {
        "dart_type": "enum_scheme_color",
        "value": "surfaceContainerHigh"
    },
    "scaffoldLightIsWhite": true,
    "schemeIndex": 58,
    "searchIsFullScreen": true,
    "searchUseGlobalShape": true,
    "showSchemeInputColors": true,
    "simulatorComponentsIndex": 2,
    "sliderTrackHeight": 6,
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
    "switchAdaptiveCupertinoLike": {
        "dart_type": "enum_adaptive_response",
        "value": "all"
    },
    "switchThumbFixedSize": false,
    "systemNavBarStyle": {
        "dart_type": "enum_flex_system_navbar_style",
        "value": "transparent"
    },
    "tabBarDividerColor": {
        "dart_type": "color",
        "value": "00000000"
    },
    "tabBarIndicatorAnimation": {
        "dart_type": "enum_tabbar_indicator_animation",
        "value": "linear"
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
    "topicIndexEndSide": 4,
    "topicIndexStartSide": 25,
    "unselectedToggleIsColored": false,
    "useError": true,
    "useKeyColors": false,
    "useM3ErrorColors": true,
    "useMaterial3Typography": true,
    "useSecondary": true,
    "useTertiary": true,
    "useToDarkMethod": false,
    "usedColors": 6,
    "usedFlexToneSetup": 0
}*/
