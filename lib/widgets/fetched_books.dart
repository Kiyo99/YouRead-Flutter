import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class FetchedBooks extends HookWidget {
  const FetchedBooks(this.snapshot, {Key? key}) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);

    if (snapshot.hasError) {
      return const Center(child: Text('Something went wrong'));
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    List<Map<String, dynamic>?>? data = snapshot.data?.docs
        .map((e) => e.data() as Map<String, dynamic>?)
        .toList();

    bookViewModel.setFetchedBooks(data);

    if (data!.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 300,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(BookViewer.id, arguments: data[index]);
            },
            child: Column(
              children: [
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          data[index]!['url'],
                          height: 180,
                          width: 180,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  data[index]!['author'] ?? "Steven Erikson",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}