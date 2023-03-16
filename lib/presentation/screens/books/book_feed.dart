import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/app_text_style.dart';
import 'package:k_books/constants.dart';
import 'package:k_books/firebase_service.dart';
import 'package:k_books/presentation/screens/books/all_books_screen.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/drawer.dart';

class BookFeed extends HookWidget {
  static String id = "book_viewer";

  const BookFeed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(FlutterRemix.menu_2_line),
            );
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(FlutterRemix.more_2_fill))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.categoriesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      'Something went wrong',
                      style: AppTextStyles.bigTextStyle,
                    ));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.purple));
                  }

                  List<Map<String, dynamic>?>? data = snapshot.data?.docs
                      .map((e) => e.data() as Map<String, dynamic>?)
                      .toList();

                  if (data!.isEmpty) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        String category = data[index]!['text'];

                        return InkWell(
                          onTap: () {
                            bookViewModel.setActiveCategory(category);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: bookViewModel.activeCategory == category
                                  ? Constants.coolBlue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  category == "Drama"
                                      ? Icons.movie_creation_outlined
                                      : category == "Horror"
                                          ? FlutterRemix.movie_2_fill
                                          : category == "Poetry"
                                              ? Icons.edit_outlined
                                              : category == "Fantasy"
                                                  ? FlutterRemix.movie_line
                                                  : FlutterRemix.movie_line,
                                  color:
                                      bookViewModel.activeCategory == category
                                          ? Constants.coolPurple
                                          : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  category,
                                  style: TextStyle(
                                      color: bookViewModel.activeCategory ==
                                              category
                                          ? Colors.white
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              if (bookViewModel.showFilteredBooks == true)
                Visibility(
                  visible: bookViewModel.filteredBooks!.isNotEmpty,
                  replacement: const Center(
                    child: Text(
                      "Nothing yet in this category",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  child: SizedBox(
                    height: 250,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: bookViewModel.filteredBooks?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(BookViewer.id,
                                arguments: bookViewModel.filteredBooks![index]);
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
                                      bookViewModel
                                          .filteredBooks![index]!['url'],
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    bookViewModel
                                        .filteredBooks![index]!['title'],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Library",
                    style: AppTextStyles.smallTextStyle,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AllBooksScreen.id);
                    },
                    child: const Text(
                      "See all",
                      style: AppTextStyles.mutedSmallTextStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.booksStream,
                builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) =>
                    bookViewModel.displayBooks(snapshot),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
