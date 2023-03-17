import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/app_search_field.dart';
import 'package:k_books/widgets/filtered_books.dart';

class SearchScreen extends HookWidget {
  static String id = "search_screen";

  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: AppSearchField(
                    title: "Search titles",
                    searchDB: (query) => bookViewModel.fetchBooks(query),
                  ),
                ),
              )
            ],
          ),
          if (bookViewModel.showBooks == true)
            Visibility(
                visible: bookViewModel.searchedBooks!.isNotEmpty,
                replacement: const Center(
                  child: Text(
                    "Couldn't find that book",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FilteredBooks(bookViewModel.searchedBooks),
                )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
