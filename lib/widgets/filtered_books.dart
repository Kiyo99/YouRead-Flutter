import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';

class FilteredBooks extends HookWidget {
  const FilteredBooks(this.data, {Key? key}) : super(key: key);

  final List<Map<String, dynamic>?>? data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: data?.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(BookViewer.id, arguments: data![index]);
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
                        data![index]!['url'],
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data![index]!['title'],
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
    );
  }
}