import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class FetchedBooks extends HookWidget {
  const FetchedBooks({Key? key, required this.origin}) : super(key: key);
  final String origin;

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);

    List<Map<String, dynamic>?>? data =
        origin == "all" ? bookViewModel.allBooks : bookViewModel.recentBooks;

    if (data!.isEmpty) {
      return Center(
        child: Text(
          "No books yet!",
          style: GoogleFonts.nunito(color: Colors.red, fontSize: 15),
        ),
      );
    }

    return SizedBox(
      height: 260,
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
                            // width: 120,
                            // color: Colors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 140,
                  child: Text(
                    data[index]!['title'],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                    style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data[index]!['author'],
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
