import 'package:get/get.dart';
import 'package:json_to_dart/screens/main/binding/main_binding.dart';
import 'package:json_to_dart/screens/main/view/main_view.dart';
import 'package:json_to_dart/screens/setting/binding/flutter_mobile_binding.dart';
import 'package:json_to_dart/screens/setting/binding/studio_template_binding.dart';
import 'package:json_to_dart/screens/setting/view/flutter_mobile_view.dart';
import 'package:json_to_dart/screens/setting/view/studio_template_view.dart';
import 'package:json_to_dart/screens/setting/view/toggle_language_view.dart';
import 'package:json_to_dart/screens/setting/view/toggle_theme_view.dart';
import 'package:json_to_dart/router/router_names.dart';

sealed class RouterPages {
  static List<GetPage> allPages() {
    return [
      GetPage(name: RouterNames.main, page: () => MainView(), binding: MainBinding()),
      GetPage(name: RouterNames.toggleTheme, page: () => ToggleThemeView()),
      GetPage(name: RouterNames.toggleLanguage, page: () => ToggleLanguageView()),
      GetPage(
        name: RouterNames.flutterMobile,
        page: () => FlutterMobileView(),
        binding: FlutterMobileBinding(),
      ),
      GetPage(
        name: RouterNames.studioTemplate,
        page: () => StudioTemplateView(),
        binding: StudioTemplateBinding(),
      ),
    ];
  }
}
