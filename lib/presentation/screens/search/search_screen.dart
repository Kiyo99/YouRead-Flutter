import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/app_search_field.dart';
import 'package:k_books/widgets/filtered_books.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends HookWidget {
  static String id = "search_screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    return SafeArea(
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: AppSearchField(
                    title: "Search titles",
                    searchDB: (query) => bookViewModel.searchBooks(query),
                  ),
                ),
              )
            ],
          ),
          bookViewModel.showBooks
              ? Visibility(
                  visible: bookViewModel.searchedBooks!.isNotEmpty,
                  replacement: Center(
                    child: Text(
                      "Couldn't find that book",
                      style: GoogleFonts.nunito(color: Colors.red),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FilteredBooks(bookViewModel.searchedBooks),
                  ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Transform.scale(
                              scale: 0.70,
                              child: Lottie.asset(
                                "assets/lottie/book_stars.json",
                                frameRate: FrameRate(60),
                              ),
                            ),
                            Text(
                              "Remember to search by book title ... happy searching!",
                              style: AppTextStyles.expGStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
