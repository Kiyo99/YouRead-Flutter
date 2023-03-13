import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/constants.dart';

class MutedAppTextField extends HookWidget {
  final TextEditingController controller;
  final String title;
  final Function()? onTap;
  final bool? obscureText;

  MutedAppTextField(
      {required this.controller,
      required this.title,
      this.obscureText,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onTap: onTap ?? () {},
        focusNode: AlwaysDisabledFocusNode(),
        obscureText: obscureText ?? false,
        cursorColor: Constants.coolOrange,
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
                borderSide: BorderSide(color: Constants.coolOrange)),
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
