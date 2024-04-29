import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/firebase/firebase_service.dart';

class BookViewModel extends ChangeNotifier {
  List<Map<String, dynamic>?>? _allBooks = [];

  List<Map<String, dynamic>?>? get allBooks => _allBooks;

  List<Map<String, dynamic>?>? _recentBooks = [];

  List<Map<String, dynamic>?>? get recentBooks => _recentBooks;

  List<Map<String, dynamic>?>? _filteredAllBooks = [];

  List<Map<String, dynamic>?>? get filteredAllBooks => _filteredAllBooks;

  List<Map<String, dynamic>?>? _filteredRecentBooks = [];

  List<Map<String, dynamic>?>? get filteredRecentBooks => _filteredRecentBooks;

  List<dynamic> _bookmarkedBooks = [];

  List<dynamic> get bookmarkedBooks => _bookmarkedBooks;

  void filterBooks(String category) {
    _showFilteredBooks = false;
    final allBooks = _allBooks?.where((book) =>
        book!['category'].toString().toLowerCase() == category.toLowerCase());

    final recentBooks = _recentBooks?.where((book) =>
        book!['category'].toString().toLowerCase() == category.toLowerCase());

    _filteredAllBooks?.clear();
    _filteredAllBooks?.addAll(allBooks!);

    _filteredRecentBooks?.clear();
    _filteredRecentBooks?.addAll(recentBooks!);

    _showFilteredBooks = true;
    notifyListeners();
  }

  List<dynamic> _categories = [];

  List<dynamic> get categories => _categories;

  void setCategories(List<dynamic> data) {
    _categories = data;
    notifyListeners();
  }

  String _activeCategory = "";

  String get activeCategory => _activeCategory;

  void setActiveCategory(String category) {
    if (_activeCategory == category) {
      _activeCategory = "";
      _showFilteredBooks = false;
      _filteredAllBooks?.clear();
      // fetchAllBooks();
      // fetchRecentBooks();
      notifyListeners();
      return;
    }

    //todo: Something is going wrong here
    _activeCategory = category;
    filterBooks(category);
    notifyListeners();
  }

  void setFetchedBooks(List<Map<String, dynamic>?>? data) {
    _allBooks = data;
    notifyListeners();
  }

  void setBookmarkedBooks(List<dynamic> data) {
    _bookmarkedBooks = data;
    notifyListeners();
  }

  void setRecentBooks(List<Map<String, dynamic>?>? data) {
    _recentBooks = data;
    notifyListeners();
  }

  List<Map<String, dynamic>?>? _searchedBooks = [];

  List<Map<String, dynamic>?>? get searchedBooks => _searchedBooks;

  bool _showBooks = false;

  bool get showBooks => _showBooks;

  bool _showCatLoader = false;

  bool get showCatLoader => _showCatLoader;

  bool _showBookmarkLoader = false;

  bool get showBookmarkLoader => _showBookmarkLoader;

  bool _showAllLoader = false;

  bool get showAllLoader => _showAllLoader;

  bool _showRecentLoader = false;

  bool get showRecentLoader => _showRecentLoader;

  bool _showFilteredBooks = false;

  bool get showFilteredBooks => _showFilteredBooks;

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _showBooks = false;
      notifyListeners();
      return;
    }
    _showBooks = false;

    final data = await FirebaseService.fetchBooks();

    setFetchedBooks(data);

    final books = _allBooks?.where((book) =>
        book!['title'].toString().toLowerCase().contains(query.toLowerCase()));

    _searchedBooks?.clear();
    _searchedBooks?.addAll(books!);
    _showBooks = true;
    notifyListeners();
  }

  Future<void> getRecentBooks() async {
    _showRecentLoader = true;
    notifyListeners();

    final data = await FirebaseService.fetchRecentBooks();

    setRecentBooks(data);

    // _searchedBooks?.clear();
    // _searchedBooks?.addAll(books!);
    _showRecentLoader = false;
    notifyListeners();
  }

  Future<void> getAllBooks() async {
    _showAllLoader = true;
    notifyListeners();

    final data = await FirebaseService.fetchBooks();

    setFetchedBooks(data);

    // _searchedBooks?.clear();
    // _searchedBooks?.addAll(books!);
    _showAllLoader = false;
    notifyListeners();
  }

  Future<void> getCategories() async {
    _showCatLoader = true;
    notifyListeners();

    final data = await FirebaseService.fetchCategories();

    setCategories(data);

    // _searchedBooks?.clear();
    // _searchedBooks?.addAll(books!);
    _showCatLoader = false;
    notifyListeners();
  }

  Future<void> getBookmarks() async {
    _showBookmarkLoader = true;
    notifyListeners();

    final userData = await FirebaseService.fetchUser();

    setBookmarkedBooks(userData?['bookmarks']);

    _showBookmarkLoader = false;
    notifyListeners();
  }

  static final provider =
      ChangeNotifierProvider.autoDispose((ref) => BookViewModel());
}
