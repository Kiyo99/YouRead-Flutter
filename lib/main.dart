import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/core/firebase/firebase_options.dart';
import 'package:k_books/presentation/screens/auth/intro_screen.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/presentation/screens/auth/splash_screen.dart';
import 'package:k_books/presentation/screens/bookmark/bookmarks_screen.dart';
import 'package:k_books/presentation/screens/books/all_books_screen.dart';
import 'package:k_books/presentation/screens/books/book_feed.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';
import 'package:k_books/presentation/screens/main_app.dart';
import 'package:k_books/presentation/screens/misc/about_screen.dart';
import 'package:k_books/presentation/screens/misc/settings_screen.dart';
import 'package:k_books/presentation/screens/profile/profile_screen.dart';
import 'package:k_books/presentation/screens/search/search_screen.dart';
import 'package:k_books/presentation/screens/upload/upload_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    name: 'kbooks-d91c6',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureFCM();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final token = await _firebaseMessaging.getToken();

  _firebaseMessaging.subscribeToTopic('test');

  print("Tokennnnn: $token");

  // _requestPermissions();
  await _initNotifications();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
          useInheritedMediaQuery: true,
          // darkTheme: ThemeData.dark(),
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Constants.coolBlue),
          //   useMaterial3: true,
          // ),
          theme: ThemeData.light(),
          title: 'YouRead',
          debugShowCheckedModeBanner: false,
          routes: {
            BookViewer.id: (context) => BookViewer(),
            MainApp.id: (context) => const MainApp(),
            BookFeed.id: (context) => const BookFeed(),
            UploadScreen.id: (context) => UploadScreen(),
            SettingsScreen.id: (context) => const SettingsScreen(),
            AboutScreen.id: (context) => const AboutScreen(),
            SearchScreen.id: (context) => const SearchScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
            BookmarksScreen.id: (context) => const BookmarksScreen(),
            AllBooksScreen.id: (context) => const AllBooksScreen(),
            SummaryScreen.id: (context) => const SummaryScreen(),
            LoginPage.id: (context) => LoginPage(),
            IntroScreen.id: (context) => const IntroScreen(),
          },
          home: const SplashScreen()),
    );
  }
}

void configureFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Extract the data from the FCM message.
    String title = message.notification?.title ?? '';
    String body = message.notification?.body ?? '';
    Map<String, dynamic> data = message.data;

    print("title: $title");
    print("body: $body");
    print("data: $data");

    // Handle or display the data as needed.
    _displayNotification(message);
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initNotifications() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void _displayNotification(RemoteMessage message) async {
  print("titlee: ${message.notification?.title}");
  print("bodyy: ${message.notification?.body}");
  print("dataa: ${message.data}");
  var android = const AndroidNotificationDetails(
    'your_channel_id',
    'Your Channel Name',
    // 'Your Channel Description',
    // icon: 'assets/images/icon_2.png'
  );

  var ios = const DarwinNotificationDetails(
    sound: 'your_custom_sound.aiff',
    // Provide a custom sound file.
    presentSound: true,
    badgeNumber: 1,
    presentAlert: true,
    presentBadge: true,
  );
  var platform = NotificationDetails(android: android, iOS: ios);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    platform,
  );
}

// Future<void> _requestPermissions() async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   final IOSNotificationSettings iosSettings = await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       IOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (iosSettings.authorizationStatus ==
//       AuthorizationStatus.authorized) {
//     print('Notification permissions granted.');
//   } else {
//     print('Notification permissions denied.');
//   }
// }
