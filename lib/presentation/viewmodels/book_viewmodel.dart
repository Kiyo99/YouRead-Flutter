import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/firebase_service.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';

class BookViewModel extends ChangeNotifier {
  final AutoDisposeProviderReference _ref;

  BookViewModel(this._ref);

  List<Map<String, dynamic>?>? _fetchedBooks = [];
  List<Map<String, dynamic>?>? get fetchedBooks => _fetchedBooks;

  List<Map<String, dynamic>?>? _filteredBooks = [];
  List<Map<String, dynamic>?>? get filteredBooks => _filteredBooks;

  void filterBooks(String category) {
    print("HERE: $category");
    print("fe: ${_fetchedBooks?.length}");
    _showFilteredBooks = false;
    final books = _fetchedBooks?.where((book) => book!['category']
        .toString()
        .toLowerCase()
        .contains(category.toLowerCase()));

    print("feeeee: ${books?.length}");

    _filteredBooks?.clear();
    _filteredBooks?.addAll(books!);
    print("fddddeeeee: ${_filteredBooks?.length}");

    _showFilteredBooks = true;
    notifyListeners();
  }

  String _activeCategory = "";
  String get activeCategory => _activeCategory;

  void setActiveCategory(String category) {
    if (_activeCategory == category) {
      _activeCategory = "";
      _showFilteredBooks = false;
      _filteredBooks?.clear();
      notifyListeners();
      return;
    }
    _activeCategory = category;
    filterBooks(category);
    notifyListeners();
  }

  void setFetchedBooks(List<Map<String, dynamic>?>? data) {
    _fetchedBooks = data;
    notifyListeners();
  }

  List<Map<String, dynamic>?>? _searchedBooks = [];
  List<Map<String, dynamic>?>? get searchedBooks => _searchedBooks;

  bool _showBooks = false;
  bool get showBooks => _showBooks;

  bool _showFilteredBooks = false;
  bool get showFilteredBooks => _showFilteredBooks;

  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) {
      _showBooks = false;
      return;
    }
    _showBooks = false;

    final data = await FirebaseService.fetchBooks();

    setFetchedBooks(data);

    //
    final books = _fetchedBooks?.where((book) =>
        book!['title'].toString().toLowerCase().contains(query.toLowerCase()));

    _searchedBooks?.clear();
    _searchedBooks?.addAll(books!);
    _showBooks = true;
    notifyListeners();
  }

  Widget displayBooks(AsyncSnapshot<QuerySnapshot> snapshot) {
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
  }

  Widget displayFilteredBooks() {
    return SizedBox();
  }

  static final provider = ChangeNotifierProvider.autoDispose(
    (ref) => BookViewModel(ref),
  );
}
