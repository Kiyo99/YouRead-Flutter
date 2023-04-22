import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_books/core/constants.dart';

class AboutScreen extends HookWidget {
  static String id = "about_screen";

  const AboutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.coolBlue,
        shadowColor: Colors.transparent,
      ),
      body: Container(),
    );
  }
}
