import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';

class SplashView extends GetView<SplashLogic> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
