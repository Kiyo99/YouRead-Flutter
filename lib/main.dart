import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/screens/book.dart';
import 'package:k_books/firebase_options.dart';
import 'package:k_books/screens/book_viewer.dart';
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
            BookViewer.id: (context) => const BookViewer(),
            BookFeed.id: (context) => const BookFeed(),
          },
          home: const BookFeed()),
    );
  }
}

//Todo: SetUp a viewModel to store the books, use ChangeNotifier
//Todo: Create a portal to upload images and pdfs
