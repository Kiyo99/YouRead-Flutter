import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/screens/about_screen.dart';
import 'package:k_books/screens/books/all_books_screen.dart';
import 'package:k_books/screens/books/book_feed.dart';
import 'package:k_books/firebase_options.dart';
import 'package:k_books/screens/books/book_viewer.dart';
import 'package:k_books/screens/favourites_screen.dart';
import 'package:k_books/screens/login_page.dart';
import 'package:k_books/screens/settings_screen.dart';
import 'package:k_books/screens/upload_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
          useInheritedMediaQuery: true,
          // darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          title: 'KBooks',
          debugShowCheckedModeBanner: false,
          routes: {
            BookViewer.id: (context) => BookViewer(),
            BookFeed.id: (context) => const BookFeed(),
            UploadScreen.id: (context) => UploadScreen(),
            SettingsScreen.id: (context) => const SettingsScreen(),
            AboutScreen.id: (context) => const AboutScreen(),
            FavouritesScreen.id: (context) => const FavouritesScreen(),
            AllBooksScreen.id: (context) => const AllBooksScreen(),
            LoginPage.id: (context) => LoginPage(),
          },
          home: const BookFeed()),
    );
  }
}

//Todo: SetUp a viewModel to store the books, use ChangeNotifier
//Todo: Create a portal to upload images and pdfs
//Todo: book => title, storage, url, category, reads
//Todo: look at app drawer header
//Todo: look at page number and resumption
