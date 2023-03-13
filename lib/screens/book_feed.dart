import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/widgets/drawer.dart';
import 'package:k_books/screens/book_viewer.dart';

class BookFeed extends HookWidget {
  static String id = "book_viewer";

  const BookFeed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const smallTextStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
    const mutedSmallTextStyle = TextStyle(
        color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20);
    const verySmallTextStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    const bigTextStyle = TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold);

    final Stream<QuerySnapshot> _booksStream =
        FirebaseFirestore.instance.collection("books").snapshots();
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection("categories").snapshots();

    final fetchedBooks = useState<List<Map<String, dynamic>?>?>([]);
    final searchedBooks = useState<List<Map<String, dynamic>?>?>([]);
    final showBooks = useState(false);

    void fetchBooks(String query) {
      if (query.isEmpty) {
        showBooks.value = false;
        return;
      }
      showBooks.value = false;
      //
      final books = fetchedBooks.value?.where((book) => book!['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()));

      searchedBooks.value?.clear();
      searchedBooks.value?.addAll(books!);
      showBooks.value = true;
    }

    return Scaffold(
      drawer: AppDrawer(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Explore",
                    style: bigTextStyle,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (query) => fetchBooks(query),
                      onSubmitted: (query) => fetchBooks(query),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_outlined),
                          hintText: "Find a book"),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              if (showBooks.value == true)
                Visibility(
                  visible: searchedBooks.value!.isNotEmpty,
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
                      itemCount: searchedBooks.value?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(BookViewer.id,
                                arguments: searchedBooks.value![index]);
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
                                      searchedBooks.value![index]!['url'],
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    searchedBooks.value![index]!['title'],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Library",
                    style: smallTextStyle,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See all",
                      style: mutedSmallTextStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _booksStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            Get.toNamed(BookViewer.id, arguments: data[index]);
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
                                      data[index]!['url'],
                                      height: 150,
                                      width: 150,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Popular now",
                    style: smallTextStyle,
                  ),
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: 0.5,
                      color: Colors.blueGrey,
                      backgroundColor: Colors.grey,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _booksStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  fetchedBooks.value = data;

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
                            Get.toNamed(BookViewer.id, arguments: data[index]);
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
                                      data[index]!['url'],
                                      height: 150,
                                      width: 150,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Text(
                    "Categories",
                    style: smallTextStyle,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _categoriesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                      'Something went wrong',
                      style: bigTextStyle,
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
                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  data[index]!['text'] == "Drama"
                                      ? Icons.movie_creation_outlined
                                      : data[index]!['text'] == "Horror"
                                          ? FlutterRemix.movie_2_fill
                                          : data[index]!['text'] == "Poetry"
                                              ? Icons.edit_outlined
                                              : data[index]!['text'] ==
                                                      "Fantasy"
                                                  ? FlutterRemix.movie_line
                                                  : FlutterRemix.movie_line,
                                ),
                                const SizedBox(width: 5),
                                Text("${data[index]!['text']}"),
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
            ],
          ),
        ),
      ),
    );
  }
}
