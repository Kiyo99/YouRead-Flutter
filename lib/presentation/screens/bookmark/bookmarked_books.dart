import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class BookmarkedBooks extends HookWidget {
  const BookmarkedBooks({Key? key, required this.books}) : super(key: key);

  final List<dynamic> books;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text("No books at the moment"));
    }
    final _fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final bookViewModel = useProvider(BookViewModel.provider);

    return RefreshIndicator(
      onRefresh: () async {
        final userDoc = await _fireStore
            .collection("Users")
            .doc(auth.currentUser?.email)
            .get();

        final userData = userDoc.data();

        bookViewModel.setBookmarkedBooks(userData?['bookmarks']);
      },
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: books
            .asMap()
            .map((index, e) => MapEntry(
                  index,
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(SummaryScreen.id, arguments: books[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.only(top: 30),
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
                                    books[index]['url'],
                                    height: 200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            books[index]['title'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            books[index]['author'],
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
      ),
    );
  }
}
