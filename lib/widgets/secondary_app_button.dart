import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';

class SecondaryAppButton extends HookWidget {
  const SecondaryAppButton(
      {Key? key, required this.title, required this.onPressed, this.padding})
      : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.nunito(color: Constants.coolBlue),
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Constants.coolBlue,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}
