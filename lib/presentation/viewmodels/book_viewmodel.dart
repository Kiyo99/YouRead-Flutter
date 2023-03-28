import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/firebase/firebase_service.dart';

class BookViewModel extends ChangeNotifier {
  final AutoDisposeProviderReference _ref;

  BookViewModel(this._ref);

  List<Map<String, dynamic>?>? _fetchedBooks = [];
  List<Map<String, dynamic>?>? get fetchedBooks => _fetchedBooks;

  List<Map<String, dynamic>?>? _orderedBooks = [];
  List<Map<String, dynamic>?>? get orderedBooks => _orderedBooks;

  List<Map<String, dynamic>?>? _filteredBooks = [];
  List<Map<String, dynamic>?>? get filteredBooks => _filteredBooks;

  void filterBooks(String category) {
    _showFilteredBooks = false;
    final books = _fetchedBooks?.where((book) => book!['category']
        .toString()
        .toLowerCase()
        .contains(category.toLowerCase()));

    _filteredBooks?.clear();
    _filteredBooks?.addAll(books!);

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

  void setOrderedBooks(List<Map<String, dynamic>?>? data) {
    _orderedBooks = data;
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
      notifyListeners();
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

  static final provider = ChangeNotifierProvider.autoDispose(
    (ref) => BookViewModel(ref),
  );
}
