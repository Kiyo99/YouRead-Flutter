import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/constants.dart';
import 'package:k_books/screens/about_screen.dart';
import 'package:k_books/screens/books/book_feed.dart';
import 'package:k_books/screens/favourites_screen.dart';
import 'package:k_books/screens/upload_screen.dart';
import 'package:k_books/widgets/app_drawer.dart';

class AppDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
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
                  // NavTile(
                  //   icon: FlutterRemix.home_2_line,
                  //   title: "Home",
                  //   onPressed: () => Get.toNamed(BookFeed.id),
                  // ),
                  NavTile(
                    icon: FlutterRemix.bookmark_3_line,
                    title: "Favourites",
                    onPressed: () => Get.toNamed(SettingsScreen.id),
                  ),
                  // NavTile(
                  NavTile(
                      icon: FlutterRemix.upload_2_line,
                      title: "Upload",
                      onPressed: () => Get.toNamed(UploadScreen.id)),
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
