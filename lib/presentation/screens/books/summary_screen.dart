import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/app_user/app_user.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/app_dialogs.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class SummaryScreen extends HookWidget {
  static String id = "summary_screen";

  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    final data = useState<Map<String, dynamic>>(Get.arguments);

    final user = context.read(AuthLocalDataSource.provider).getCachedUser();
    final appUser = useState<AppUser?>(user);

    final _fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    Future<void> updateUser() async {
      final studentsDoc = await _fireStore
          .collection("Users")
          .doc(auth.currentUser?.email)
          .get();

      final user = AppUser.fromJson(studentsDoc.data()!);

      context.read(AuthLocalDataSource.provider).cacheUser(user);

      appUser.value = user;

      print("Userrrrr: ${appUser.value}");

      Constants.showToast(context, 'Success');
    }

    Future<bool> bookmarkeddd() async {
      final userDoc = await _fireStore
          .collection("Users")
          .doc(auth.currentUser?.email)
          .get();

      final userDetails = userDoc.data();

      final currentBookmarks = userDetails?['bookmarks'] as List;

      final isBookmarked = currentBookmarks
          .where((book) => book['title'] == data.value['title']);

      return isBookmarked.isNotEmpty ? true : false;
    }

    final fillBookmark = useState(false);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        fillBookmark.value = await bookmarkeddd();
      });
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          data.value['title'],
          style: AppTextStyles.boldedStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.coolBlue,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 360,
                    child: Stack(
                      children: [
                        Image.network(
                          data.value['url'],
                          fit: BoxFit.cover,
                          width: 400,
                          height: 280,
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      data.value['url'],
                                      height: 250,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Author: ${data.value['author']}",
                                  style: AppTextStyles.mutedSmallTextStyle,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "November 14, 2016",
                                  style: AppTextStyles.mutedVerySmallTextStyle,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Synopsis",
                        style: AppTextStyles.titleTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(shrinkWrap: true, children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.value['synopsis'],
                              style: AppTextStyles.normalSmallTextStyle,
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    try {
                      AppDialogs.loader();
                      final userDoc = await _fireStore
                          .collection("Users")
                          .doc(auth.currentUser?.email)
                          .get();

                      final userDetails = userDoc.data();

                      final currentBookmarks =
                          userDetails?['bookmarks'] as List;

                      if (currentBookmarks.isEmpty) {
                        Map<String, Object> db = {};
                        db['bookmarks'] = [data.value];

                        _fireStore
                            .collection("Users")
                            .doc(auth.currentUser!.email.toString())
                            .update(db);

                        updateUser();

                        fillBookmark.value = await bookmarkeddd();
                        Get.back();
                        return;
                      }

                      final isBookmarked = currentBookmarks.where(
                          (book) => book['title'] == data.value['title']);

                      if (isBookmarked.isEmpty) {
                        currentBookmarks.add(data.value);
                      } else {
                        currentBookmarks.removeWhere(
                            (book) => book['title'] == data.value['title']);
                      }

                      await _fireStore
                          .collection("Users")
                          .doc(auth.currentUser?.email)
                          .update({"bookmarks": FieldValue.delete()});

                      await _fireStore
                          .collection("Users")
                          .doc(auth.currentUser?.email)
                          .update({
                        "bookmarks": FieldValue.arrayUnion(currentBookmarks),
                      });

                      updateUser();
                      fillBookmark.value = await bookmarkeddd();
                      Get.back();
                    } catch (e) {
                      Constants.showToast(context, 'Failed to save bookmark');
                      print('Failed: $e');
                    }
                  },
                  icon: fillBookmark.value
                      ? const Icon(FlutterRemix.bookmark_2_fill)
                      : const Icon(FlutterRemix.bookmark_line),
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                ),
                Expanded(
                    child: PrimaryAppButton(
                        title: "Read",
                        onPressed: () =>
                            Get.toNamed(BookViewer.id, arguments: data.value)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
