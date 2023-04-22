import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/presentation/screens/misc/about_screen.dart';
import 'package:k_books/presentation/screens/misc/settings_screen.dart';
import 'package:k_books/presentation/screens/upload/upload_screen.dart';
import 'package:k_books/widgets/app_drawer.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class AppDrawer extends HookWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(),
      decoration: BoxDecoration(
        color: Constants.coolBlue,
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                "assets/images/icon_1.png",
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  NavTile(
                      icon: FlutterRemix.upload_2_line,
                      title: "Upload",
                      onPressed: () => Get.toNamed(UploadScreen.id)),
                  NavTile(
                      icon: FlutterRemix.parent_line,
                      title: "Parental Guide",
                      onPressed: () {}),
                  NavTile(
                      icon: FlutterRemix.settings_2_line,
                      title: "Settings",
                      onPressed: () => Get.toNamed(SettingsScreen.id)),
                  NavTile(
                      icon: FlutterRemix.information_line,
                      title: "About",
                      onPressed: () => Get.toNamed(AboutScreen.id)),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: PrimaryAppButton(
                  title: "Log out",
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  bgColor: Constants.coolWhite,
                  textColor: Constants.coolBlue,
                  onPressed: () async {
                    AppModal.showModal(
                        context: context,
                        title: "Log out?",
                        message: "Are you sure you want to log out?",
                        asset: "assets/lottie/warning.json",
                        primaryAction: () async {
                          final auth = FirebaseAuth.instance;
                          //
                          await auth.signOut();

                          context
                              .read(AuthLocalDataSource.provider)
                              .clearUserData();

                          // print(auth.currentUser);
                          Get.offAndToNamed(LoginPage.id);
                        },
                        buttonText: "Yes, log out",
                        showSecondary: true);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
