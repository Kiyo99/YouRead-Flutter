import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/bookmark/bookmarks_screen.dart';
import 'package:k_books/presentation/screens/books/book_feed.dart';
import 'package:k_books/presentation/screens/profile/profile_screen.dart';
import 'package:k_books/presentation/screens/search/search_screen.dart';

class MainApp extends HookWidget {
  static const id = 'main_app';

  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = useState(0);
    PageController pageController = PageController();

    final navBottom = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(FlutterRemix.home_7_fill), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(FlutterRemix.bookmark_3_line), label: "Bookmarks"),
        BottomNavigationBarItem(
            icon: Icon(FlutterRemix.search_2_line), label: "Search"),
        BottomNavigationBarItem(
            icon: Icon(FlutterRemix.account_circle_line), label: "Profile"),
      ],
      currentIndex: _selectedIndex.value,
      showUnselectedLabels: true,
      selectedItemColor: Constants.coolBlue,
      selectedLabelStyle:
          GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle:
          GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _selectedIndex.value = index;
        // pageController.animateToPage(_selectedIndex.value, duration: const Duration(milliseconds: 1000), curve: Curves.bounceOut);
        pageController.jumpToPage(_selectedIndex.value);
      },
    );

    final navBody = PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        _selectedIndex.value = value;
      },
      children: [
        const BookFeed(),
        const BookmarksScreen(),
        const SearchScreen(),
        ProfileScreen(),
      ],
    );

    return Scaffold(
      // appBar: topAppBar,
      body: navBody,
      bottomNavigationBar: navBottom,
    );
  }
}
