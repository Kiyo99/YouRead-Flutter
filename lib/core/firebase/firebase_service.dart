import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<List<Map<String, dynamic>?>> fetchBooks() async {
    final fireStore = FirebaseFirestore.instance;
    final searchedBooks = await fireStore.collection("books").get();
    List<Map<String, dynamic>?>? data =
        searchedBooks.docs.map((e) => e.data()).toList();
    print("Gotten books: ${data.length}");
    return data;
  }
}
