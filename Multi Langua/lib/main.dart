import 'package:dict/config/routes.dart';
import 'package:dict/constant/sharedpref_key.dart';
import 'package:dict/controller/notification_controller.dart';
import 'package:dict/model/translate_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


String translatedata='';
Tran glotran=Tran(from: '', to: '');
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  SharedPreferences shared=await SharedPreferences.getInstance();
  String? input=shared.getString(SharedPrefKey.inputTranslateCountry);
  String? via=shared.getString(SharedPrefKey.translateCountry);
  if (input==null) {
    shared.setString(SharedPrefKey.inputTranslateCountry, 'en,English');
  }
  if (via == null) {
    shared.setString(SharedPrefKey.translateCountry, 'my,Myanmar');
  }
  NotificationController.startListeningNotificationEvents();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Langua',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: Routes.routeGenerator,
    );
  }
}