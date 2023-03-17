import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';

class AppIcons extends HookWidget {
  const AppIcons(this.category, {Key? key}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);

    return Icon(
      category == "Drama"
          ? Icons.movie_creation_outlined
          : category == "Horror"
              ? FlutterRemix.movie_2_fill
              : category == "Poetry"
                  ? Icons.edit_outlined
                  : category == "Fantasy"
                      ? FlutterRemix.book_2_line
                      : FlutterRemix.movie_line,
      color: bookViewModel.activeCategory == category
          ? Constants.coolPurple
          : Colors.grey,
    );
  }
}
