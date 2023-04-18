import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const AppUser._();

  factory AppUser({
    dynamic firstName,
    dynamic lastName,
    dynamic fullName,
    dynamic email,
    dynamic phoneNumber,
    dynamic gender,
    dynamic status,
    dynamic booksRead,
    dynamic boomarks,
    dynamic profilePicture,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> map) => _$AppUserFromJson(map);
}
