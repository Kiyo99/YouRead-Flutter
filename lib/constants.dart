import 'package:flutter/material.dart';

class Constants {
  //colors
  static Color blueish = const Color(0xff181D3D);
  static Color coolBlue = const Color(0xff233973);
  // static Color coolBlue = Colors.blueGrey.shade900;
  static Color coolGrey = const Color(0xffbfbfbf);
  static Color coolWhite = const Color(0xfff9f9f9);
  static Color coolPurple = const Color(0xffD096FD);

  static Color secondaryBlue = const Color(0xff111111);
  static Color coolOrange = const Color(0xffff9933);
  static Color coolRed = const Color(0xff742525);

  //Toast
  static void showToast(BuildContext context, String message) {
    final brightness = Theme.of(context).brightness;
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: coolWhite),
        ),
        action: SnackBarAction(
          label: 'Got it',
          textColor: coolWhite,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  // Pref keys
  static const prefsUserKey = 'PREFS_USER_KEY';
  static const prefsViewedKey = 'PREFS_VIEWED_KEY';

  //themes
  static final ThemeData darkTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: coolBlue,
          selectedItemColor: Constants.coolOrange,
          unselectedItemColor: Colors.grey,
          elevation: 0),
      cardTheme: CardTheme(color: coolBlue),
      appBarTheme: AppBarTheme(
        backgroundColor: coolBlue,
        iconTheme: IconThemeData(color: coolWhite),
      ),
      primaryColor: coolBlue,
      bottomAppBarColor: coolBlue,
      scaffoldBackgroundColor: coolBlue,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: coolOrange,
          background: coolBlue,
          brightness: Brightness.dark,
          primary: coolBlue));

  static final ThemeData lightTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: coolWhite,
          selectedItemColor: Constants.coolOrange,
          unselectedItemColor: Colors.grey,
          elevation: 0),
      appBarTheme: AppBarTheme(
        backgroundColor: coolOrange,
        iconTheme: IconThemeData(color: coolBlue),
      ),
      bottomAppBarColor: coolWhite,
      scaffoldBackgroundColor: coolWhite,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: coolOrange,
          background: coolWhite,
          brightness: Brightness.light,
          primary: coolWhite));
}
