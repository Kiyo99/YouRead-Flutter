import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_books/widgets/app_drawer.dart';

class AppDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  NavTile(
                    icon: Icons.list,
                    title: "Favourites",
                    onPressed: () {},
                  ),
                  // NavTile(
                  NavTile(
                      icon: Icons.settings,
                      title: "Settings",
                      onPressed: () {}),
                  NavTile(
                      icon: Icons.info_outlined,
                      title: "About",
                      onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
