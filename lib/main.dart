import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/theme/app_theme.dart';
import 'package:json_to_dart/router/router_pages.dart';
import 'package:json_to_dart/screens/splash/binding/splash_binding.dart';
import 'package:json_to_dart/screens/splash/view/splash_view.dart';
import 'package:json_to_dart/services/storage_services.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  await initServices();
  runApp(const JsonToDartApp());
}

Future<void> initServices() async {
  await Get.putAsync(() async => await StorageServices().init());
}

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.advancedJsonConversionTool,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: SplashView(),
        initialBinding: SplashBinding(),
        getPages: RouterPages.allPages(),
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
      ),
    );
  }
}
