import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class FetchedBooks extends HookWidget {
  const FetchedBooks({Key? key, required this.snapshot, required this.origin})
      : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final String origin;

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);

    if (snapshot.hasError) {
      return const Center(child: Text('Something went wrong'));
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
          child: CircularProgressIndicator(color: Constants.coolBlue));
    }

    List<Map<String, dynamic>?>? data = snapshot.data?.docs
        .map((e) => e.data() as Map<String, dynamic>?)
        .toList();

    origin == "bookStream"
        ? bookViewModel.setFetchedBooks(data)
        : bookViewModel.setOrderedBooks(data);

    if (data!.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(SummaryScreen.id, arguments: data[index]);
            },
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data[index]!['url'],
                            height: 180,
                            // width: 180,
                            // color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data[index]!['title'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  data[index]!['author'],
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
