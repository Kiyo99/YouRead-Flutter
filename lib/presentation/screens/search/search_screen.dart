import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/constants.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class SearchScreen extends HookWidget {
  static String id = "search_screen";

  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    print("Current books: ${bookViewModel.fetchedBooks?.length}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        elevation: 0,
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
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
                child: SizedBox(
                  height: 250,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: bookViewModel.searchedBooks?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(BookViewer.id,
                              arguments: bookViewModel.searchedBooks![index]);
                        },
                        child: Card(
                          color: Colors.grey.shade100,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.network(
                                    bookViewModel.searchedBooks![index]!['url'],
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  bookViewModel.searchedBooks![index]!['title'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//todo: Look at
