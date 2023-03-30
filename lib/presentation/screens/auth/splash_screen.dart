import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/auth/intro_screen.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/presentation/screens/main_app.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends HookWidget {
  static const id = "/sp";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    User? authUser = auth.currentUser;
    final viewedIntro =
        context.read(AuthLocalDataSource.provider).viewedIntro();

    Future.delayed(const Duration(seconds: 5), () {
      if (authUser == null) {
        if (viewedIntro == null) {
          Get.offNamed(IntroScreen.id);
        } else {
          Get.offNamed(LoginPage.id);
        }
      } else {
        Get.offNamed(MainApp.id);
      }
    });
    return Scaffold(
      backgroundColor: Constants.coolWhite,
      body: Center(
        child: Transform.scale(
          scale: 1,
          child: Lottie.asset(
            "assets/lottie/book_world.json",
            animate: true,
          ),
        ),
      ),
    );
  }
}
