import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavTile extends StatelessWidget {
  const NavTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed,
      this.trailing,
      this.color,
      this.padding})
      : super(key: key);

  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? color;
  final EdgeInsets? padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -2.5),
      contentPadding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        icon,
        color: color ?? Colors.white.withOpacity(0.7),
      ),
      title: Text(
        title,
        style:
            GoogleFonts.nunito(color: color ?? Colors.white.withOpacity(0.7)),
      ),
      onTap: onPressed,
      trailing: trailing ?? const SizedBox(),
    );
  }
}
