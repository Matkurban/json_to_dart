import 'package:get/get.dart';
import 'package:json_to_dart/common/setting/view/toggle_language_view.dart';
import 'package:json_to_dart/common/setting/view/toggle_theme_view.dart';
import 'package:json_to_dart/router/router_names.dart';

sealed class RouterPages {
  static List<GetPage> allPages() {
    return [
      GetPage(name: RouterNames.toggleTheme, page: () => ToggleThemeView()),
      GetPage(name: RouterNames.toggleLanguage, page: () => ToggleLanguageView()),
    ];
  }
}
