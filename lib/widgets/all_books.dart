import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class AllBooks extends HookWidget {
  const AllBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    print("Here: ${bookViewModel.fetchedBooks!.length}");

    if (bookViewModel.fetchedBooks!.isEmpty) {
      return const Center(child: Text("No books at the moment"));
    }

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: bookViewModel.fetchedBooks!
          .asMap()
          .map((index, e) => MapEntry(
                index,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(SummaryScreen.id,
                        arguments: bookViewModel.fetchedBooks![index]);
                  },
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  bookViewModel.fetchedBooks![index]!['url'],
                                  height: 200,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          bookViewModel.fetchedBooks![index]!['title'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          bookViewModel.fetchedBooks![index]!['author'],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .values
          .toList(),
    );
  }
}
