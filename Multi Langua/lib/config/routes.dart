import 'package:dict/model/listening_question.dart';
import 'package:dict/ui/pages/home/my_home_page.dart';
import 'package:dict/ui/pages/languages/language_list_page.dart';
import 'package:dict/ui/pages/listen_result_page/listen_result_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case MyHomePage.route:
        return makeRoute(const MyHomePage(), settings);

      case LanguageListPage.route:
        return makeRoute(LanguageListPage(selectedCode: argument as String,), settings);

      case ListenResultPage.route:
      return makeRoute(ListenResultPage(listenQuestlist: argument as List<ListenQuest>,), settings);
    }
    return null;
  }
}

Route? makeRoute(Widget widget, RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) {
      return widget;
    },
    settings: settings,
  );
}
