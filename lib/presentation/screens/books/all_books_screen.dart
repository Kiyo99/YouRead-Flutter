import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/all_books.dart';
import 'package:k_books/widgets/book_icons.dart';

class AllBooksScreen extends HookWidget {
  static String id = "all_books_screen";

  const AllBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    final String origin = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: bookViewModel.categories.length,
              itemBuilder: (BuildContext context, int index) {
                String category = bookViewModel.categories[index];

                return InkWell(
                  onTap: () {
                    bookViewModel.setActiveCategory(category);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: bookViewModel.activeCategory == category
                          ? Constants.coolBlue
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        AppIcons(category),
                        const SizedBox(width: 10),
                        Text(
                          category,
                          style: GoogleFonts.nunito(
                              color: bookViewModel.activeCategory == category
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AllBooks(
              books: bookViewModel.showFilteredBooks == true
                  ? bookViewModel.filteredBooks
                  : origin == "bookStream"
                      ? bookViewModel.allBooks
                      : bookViewModel.recentBooks,
            ),
          ),
        ],
      ),
    );
  }
}
