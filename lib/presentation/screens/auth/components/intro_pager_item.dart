import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPagerItem extends HookWidget {
  final IntroPagerModel slide;

  const IntroPagerItem({Key? key, required this.slide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Lottie.asset(slide.lottiePath),
        ),
        Text(
          slide.title,
          style: GoogleFonts.exo2(fontSize: 25, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.exo2(fontSize: 16),
            )),
      ],
    );
  }
}

class IntroPagerModel {
  final String lottiePath;
  final String title;
  final String description;

  const IntroPagerModel({
    Key? key,
    required this.lottiePath,
    required this.title,
    required this.description,
  });

  static List<IntroPagerModel> get slides => [
        const IntroPagerModel(
          lottiePath: "assets/lottie/hello.json",
          title: "Okay, let's do this.",
          description:
              "Welcome to the YouRead, your number 1 go-to app for reading. Let's have a quick walkthrough, shall we?",
        ),
        const IntroPagerModel(
          lottiePath: "assets/lottie/book_world.json",
          title: "Books.",
          description:
              "We have a collection of the world's best books - specifically for you",
        ),
        const IntroPagerModel(
          lottiePath: "assets/lottie/book_turner.json",
          title: "Enter YouRead",
          description:
              "Knowledge is power! Expand your knowledge and take on the world",
        ),
        const IntroPagerModel(
          lottiePath: "assets/lottie/slow_book_stack.json",
          title: "It's all yours",
          description:
              "All books, in here, for you. Please, let's have a blast.",
        ),
      ];
}
