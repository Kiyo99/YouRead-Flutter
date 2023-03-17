import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/filtered_books.dart';

class SearchScreen extends HookWidget {
  static String id = "search_screen";

  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        elevation: 0,
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (query) => bookViewModel.fetchBooks(query),
                  onSubmitted: (query) => bookViewModel.fetchBooks(query),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      hintText: "Find a book"),
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
                child: FilteredBooks(bookViewModel.searchedBooks)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

//todo: Look at
