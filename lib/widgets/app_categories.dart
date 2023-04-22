import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/book_icons.dart';

class AppCategories extends HookWidget {
  const AppCategories(this.snapshot, this.bookViewModel, {Key? key})
      : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final BookViewModel bookViewModel;

  @override
  Widget build(BuildContext context) {
    try {
      // final bookViewModel = useProvider(BookViewModel.provider);

      if (snapshot.hasError) {
        return Center(
            child: Text(
          'Something went wrong',
          style: AppTextStyles.bigTextStyle,
        ));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
            child: CircularProgressIndicator(color: Constants.coolBlue));
      }

      List<Map<String, dynamic>?>? data = snapshot.data?.docs
          .map((e) => e.data() as Map<String, dynamic>?)
          .toList();

      final categories = data?[0]?['values'];

      if (categories!.isEmpty) {
        return const SizedBox();
      }

      bookViewModel.setCategories(categories);

      return SizedBox(
        height: 50,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            String category = categories[index];

            return InkWell(
              onTap: () {
                bookViewModel.setActiveCategory(category);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: bookViewModel.activeCategory == category
                      ? Constants.coolBlue
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    AppIcons(category),
                    const SizedBox(width: 10),
                    Text(
                      category,
                      style: TextStyle(
                          color: bookViewModel.activeCategory == category
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
    } catch (e) {
      debugPrint("Error: $e");
      return const SizedBox();
    }
  }
}
