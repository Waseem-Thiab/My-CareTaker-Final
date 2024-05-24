import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fireproject/Auth.dart';
import 'package:fireproject/Medicine_log/services/notification_service.dart';
import 'package:fireproject/Main_pages/goals/tdee.dart';
import 'package:fireproject/food/my_diary/my_diary_screen.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Initializes Awesome Notifications with a basic notification channel.
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Medicine Reminder',
        channelDescription:
            'Notifications to remind users of medication intake')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Reminder Group')
  ]);

  // Checks if the app is allowed to send notifications and requests permission if not.
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Sets listeners for different notification events.
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceiveMethod,
      onNotificationCreatedMethod:
          NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationService.onNotificationsDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationService.onDismissActionReceivedMethod,
    );

    // Schedule notifications based on the user's medicine intake schedule.
    NotificationService().scheduleNotificationsBasedOnMedicine();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/goal': (context) => GoalSelectionPage(),
        '/Auth': (context) => const Auth(),
        '/my_diary_screen': (context) => const MyDiaryScreen(),
        '/tdee': (context) => TDEEFormPage(),
        
        

      },
      debugShowCheckedModeBanner: false,
      home: const Auth(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
