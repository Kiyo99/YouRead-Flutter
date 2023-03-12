import 'package:flutter/material.dart';

class NavTile extends StatelessWidget {

  const NavTile({Key? key, required this.icon, required this.title, required this.onPressed}) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -2.5),
      leading: Icon(
        icon,
        color: Colors.white.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      onTap: onPressed,
    );
  }
}
