import 'package:get/get.dart';
import 'package:json_to_dart/screens/main/main_binding.dart';
import 'package:json_to_dart/screens/main/main_view.dart';
import 'package:json_to_dart/screens/setting/view/toggle_language_view.dart';
import 'package:json_to_dart/screens/setting/view/toggle_theme_view.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_binding.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_view.dart';
import 'package:json_to_dart/router/router_names.dart';

sealed class RouterPages {
  static List<GetPage> allPages() {
    return [
      GetPage(
        name: RouterNames.main,
        page: () => MainView(),
        binding: MainBinding(),
      ),
      GetPage(name: RouterNames.toggleTheme, page: () => ToggleThemeView()),
      GetPage(
        name: RouterNames.toggleLanguage,
        page: () => ToggleLanguageView(),
      ),
      GetPage(
        name: RouterNames.jsonGenerator,
        page: () => const JsonGeneratorView(),
        binding: JsonGeneratorBinding(),
      ),
    ];
  }
}
