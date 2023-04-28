import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/core/preference_manager.dart';
import 'package:k_books/data/app_user/app_user.dart';

class AuthLocalDataSource {
  final PreferenceManager _preferenceManager;
  static final provider = Provider<AuthLocalDataSource>(
        (ref) => AuthLocalDataSource(ref.watch(preferenceManagerProvider)),
  );

  const AuthLocalDataSource(this._preferenceManager);

  void cacheUser(AppUser user) {
    try {
      print("Incoming user: ${user}");
      _preferenceManager.saveJsonMap(Constants.prefsUserKey, user.toJson());
    } catch (e){
      print("Errrrrrr: ${e}");
    }

  }

  bool? viewedIntro() {
    return _preferenceManager.prefs.getBool(Constants.prefsViewedKey);
  }

  void setViewedIntro() {
    _preferenceManager.prefs.setBool(Constants.prefsViewedKey, true);
  }

  bool? appInstalled() {
    return _preferenceManager.prefs.getBool(Constants.prefsViewedKey);
  }

  void setAppInstalled() {
    _preferenceManager.prefs.setBool(Constants.prefsViewedKey, true);
  }

  AppUser? getCachedUser() {
    final user = _preferenceManager.getJsonMap(Constants.prefsUserKey);
    return AppUser.fromJson(user);
  }

  void clearUserData() {
    _preferenceManager.prefs.remove(Constants.prefsUserKey);
    _preferenceManager.prefs.remove(Constants.prefsViewedKey);
  }
}
