import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/firebase/firebase_options.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/presentation/screens/author/upload_screen.dart';
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
      child: DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

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
          theme: ThemeData.light(),
          title: 'KBooks',
          debugShowCheckedModeBanner: false,
          routes: {
            BookViewer.id: (context) => BookViewer(),
            MainApp.id: (context) => const MainApp(),
            BookFeed.id: (context) => const BookFeed(),
            UploadScreen.id: (context) => UploadScreen(),
            SettingsScreen.id: (context) => const SettingsScreen(),
            AboutScreen.id: (context) => const AboutScreen(),
            SearchScreen.id: (context) => const SearchScreen(),
            ProfileScreen.id: (context) => const ProfileScreen(),
            BookmarksScreen.id: (context) => const BookmarksScreen(),
            AllBooksScreen.id: (context) => const AllBooksScreen(),
            SummaryScreen.id: (context) => const SummaryScreen(),
            LoginPage.id: (context) => LoginPage(),
          },
          home: LoginPage()),
    );
  }
}

//Todo: SetUp a viewModel to store the books, use ChangeNotifier
//Todo: Create a portal to upload images and pdfs
//Todo: book => title, storage, url, category, reads, author, rating, intro, date uploaded, likes
//Todo: newest books, most popular, based by rating and date created
//Todo: zooming
//Todo: 2 modes again, reader and author
//Todo: user: books read, bookmarks
//Todo: Author: All books, follow author
//Todo: handle useProviders properly | Functions should be handled in screen, not in the widgets
//Todo: refactor uploading method to viewmodel
//Todo: Move all UseProviders away
//Todo: Set activeBook in viewModel
