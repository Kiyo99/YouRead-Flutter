import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final Stream<QuerySnapshot> booksStream =
      FirebaseFirestore.instance.collection("books").snapshots();

  static final Stream<QuerySnapshot> orderedBookStream = FirebaseFirestore
      .instance
      .collection("books")
      .orderBy("dateCreated", descending: true)
      .snapshots();

  static final Stream<QuerySnapshot> categoriesStream =
      FirebaseFirestore.instance.collection("categories").snapshots();

  final _fireStore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>?> fetchUser() async {
    final fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    final userDoc =
        await fireStore.collection("Users").doc(auth.currentUser?.email).get();

    final userData = userDoc.data();

    return userData;
  }

  static Future<List<Map<String, dynamic>?>> fetchBooks() async {
    final fireStore = FirebaseFirestore.instance;
    final searchedBooks = await fireStore.collection("books").get();
    List<Map<String, dynamic>?>? data =
        searchedBooks.docs.map((e) => e.data()).toList();
    return data;
  }

  static Future<List<Map<String, dynamic>?>> fetchRecentBooks() async {
    final fireStore = FirebaseFirestore.instance;
    final recentBooks = await fireStore
        .collection("books")
        .orderBy("dateCreated", descending: true)
        .get();
    List<Map<String, dynamic>?>? data =
        recentBooks.docs.map((e) => e.data()).toList();
    return data;
  }

  static Future<List<dynamic>> fetchCategories() async {
    final fireStore = FirebaseFirestore.instance;
    final recentBooks = await fireStore.collection("categories").get();
    List<Map<String, dynamic>?>? categories =
        recentBooks.docs.map((e) => e.data()).toList();
    final data = categories[0]!['values'];
    return data;
  }
}
