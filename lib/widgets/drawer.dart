import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/bookmark/bookmarks_screen.dart';
import 'package:k_books/presentation/screens/misc/about_screen.dart';
import 'package:k_books/presentation/screens/author/upload_screen.dart';
import 'package:k_books/presentation/screens/misc/settings_screen.dart';
import 'package:k_books/widgets/app_drawer.dart';

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
          ],
        ),
      ),
    );
  }
}
