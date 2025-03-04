import 'package:get/get.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class HighlighterLogic extends GetxController{

  late Highlighter highlighter;

  @override
  void onInit() async{
    super.onInit();
    var theme = await HighlighterTheme.loadLightTheme();
    highlighter = Highlighter(language: 'java', theme: theme);
  }
}