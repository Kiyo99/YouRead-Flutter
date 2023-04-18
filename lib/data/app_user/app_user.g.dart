// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$$_AppUserFromJson(Map<String, dynamic> json) => _$_AppUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      status: json['status'],
      booksRead: json['booksRead'],
      boomarks: json['boomarks'],
      profilePicture: json['profilePicture'],
    );

Map<String, dynamic> _$$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'gender': instance.gender,
      'status': instance.status,
      'booksRead': instance.booksRead,
      'boomarks': instance.boomarks,
      'profilePicture': instance.profilePicture,
    };
