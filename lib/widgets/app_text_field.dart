import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';

class AppTextField extends HookWidget {
  final TextEditingController controller;
  final String title;
  final bool? obscureText;
  final TextCapitalization? capitilize;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.title,
    this.obscureText,
    this.capitilize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textCapitalization: capitilize ?? TextCapitalization.none,
        obscureText: obscureText ?? false,
        cursorColor: Constants.coolBlue,
        controller: controller,
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
            labelText: title,
            labelStyle: GoogleFonts.exo2(
                color: brightness == Brightness.light
                    ? Constants.coolBlue
                    : Constants.coolWhite)),
      ),
    );
  }
}
