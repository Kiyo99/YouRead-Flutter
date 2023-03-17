import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';

class AppSearchField extends HookWidget {
  final String title;
  final Function(String query) searchDB;

  AppSearchField({
    required this.searchDB,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textCapitalization: TextCapitalization.words,
        cursorColor: Constants.coolBlue,
        onChanged: searchDB,
        onSubmitted: searchDB,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: brightness == Brightness.light
                    ? Constants.coolBlue
                    : Constants.coolWhite,
              ),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                borderSide: BorderSide(color: Constants.coolBlue)),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(FlutterRemix.search_line),
            labelText: title,
            labelStyle: GoogleFonts.exo2(
                color: brightness == Brightness.light
                    ? Constants.coolBlue
                    : Constants.coolWhite)),
      ),
    );
  }
}
