import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/presentation/screens/books/summary_screen.dart';

class AllBooks extends HookWidget {
  const AllBooks({Key? key, required this.books}) : super(key: key);

  final List<Map<String, dynamic>?>? books;

  @override
  Widget build(BuildContext context) {
    if (books!.isEmpty) {
      return const Center(child: Text("No books at the moment"));
    }

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: books!
          .asMap()
          .map((index, e) => MapEntry(
                index,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(SummaryScreen.id, arguments: books![index]);
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
                                  books![index]!['url'],
                                  height: 200,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 140,
                          child: Text(
                            books![index]!['title'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            style: GoogleFonts.nunito(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          books![index]!['author'],
                          style: GoogleFonts.nunito(
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
