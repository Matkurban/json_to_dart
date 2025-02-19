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
      primary: Color(0xFF1196DB),
      primaryContainer: Color(0xFFF4FAFF),
      primaryLightRef: Color(0xFF1196DB),
      secondary: Color(0xFF4CAF50),
      secondaryContainer: Color(0xFFFFFFFF),
      secondaryLightRef: Color(0xFF4CAF50),
      tertiary: Color(0xFF81D4FA),
      tertiaryContainer: Color(0xFFFFFFFF),
      tertiaryLightRef: Color(0xFF81D4FA),
      appBarColor: Color(0xFFFFFFFF),
      error: Color(0xFFA30000),
      errorContainer: Color(0xFFFFFFFF),
    ),
    lightIsWhite: true,
    fontFamily: "JetBrainsMono",
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      scaffoldBackgroundSchemeColor: SchemeColor.primaryContainer,
      useM2StyleDividerInM3: true,
      defaultRadius: 10.0,
      inputDecoratorSchemeColor: SchemeColor.secondary,
      inputDecoratorIsFilled: true,
      inputDecoratorBackgroundAlpha: 20,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      fabSchemeColor: SchemeColor.secondary,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onSecondary,
      tooltipOpacity: null,
      dialogBackgroundSchemeColor: SchemeColor.primaryContainer,
      useInputDecoratorThemeInDialogs: true,
      snackBarBackgroundSchemeColor: SchemeColor.onSecondary,
      appBarCenterTitle: true,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      searchUseGlobalShape: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      // Custom colors
      primary: Color(0xFF2196F3),
      primaryContainer: Color(0xFF00325B),
      primaryLightRef: Color(0xFF1196DB),
      secondary: Color(0xFFFFB59D),
      secondaryContainer: Color(0xFF872100),
      secondaryLightRef: Color(0xFF4CAF50),
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF004E59),
      tertiaryLightRef: Color(0xFF81D4FA),
      appBarColor: Color(0xFFFFFFFF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    fontFamily: "JetBrainsMono",
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 10.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedHasBorder: false,
      fabSchemeColor: SchemeColor.secondary,
      alignedDropdown: true,
      tooltipSchemeColor: SchemeColor.onSecondary,
      tooltipOpacity: null,
      useInputDecoratorThemeInDialogs: true,
      snackBarBackgroundSchemeColor: SchemeColor.onSecondary,
      appBarCenterTitle: true,
      bottomNavigationBarMutedUnselectedLabel: false,
      bottomNavigationBarMutedUnselectedIcon: false,
      searchUseGlobalShape: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
