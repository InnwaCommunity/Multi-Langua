import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:dict/constant/sharedpref_key.dart';
import 'package:dict/main.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'package:translator/translator.dart';


///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class NotificationController {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/multi_langua', //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);

        
  }
  

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) {
            onActionReceivedImplementationMethod(silentData);
            log('silentData $silentData' );
          });

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
        final translator = GoogleTranslator();
        log('onActionReceivedMethod');
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      log(
          'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
               var translation = await translator
      .translate(receivedAction.buttonKeyInput, from: glotran.from, to: glotran.to);
          translatedata=receivedAction.buttonKeyInput;
      NotificationController.createNewNotification(inputdata: receivedAction.buttonKeyInput, trandata: translation.toString());
      await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        log(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          log('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
        log('onActionReceivedImplementationMethod');
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //     (route) =>
    //         (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    log("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    log(re.body);
    log("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification({String? inputdata,String? trandata}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    
    SharedPreferences shared=await SharedPreferences.getInstance();
    String? from = shared.getString(SharedPrefKey.inputTranslateCountry);
    String? to = shared.getString(SharedPrefKey.translateCountry);
    // String title='Nyein Chann Moe Translator';
    String username= from?.split(',')[1] ?? 'English';
    String msg=to?.split(',')[1] ?? 'Myanmar';
    
    await ClearAllNotifications.clear();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          locked: true,
          id: -1,
          channelKey: 'alerts',
          title: inputdata ?? username,
          body: trandata ?? msg,
          notificationLayout: NotificationLayout.BigText,
          color: Colors.black,
          backgroundColor: Colors.black,
          // customSound: 'resource://raw/notif',
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'REPLY',
              label: 'Enter Text',
              requireInputText: true,
              actionType: ActionType.SilentAction),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Stop',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

}

