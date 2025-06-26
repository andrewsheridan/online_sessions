// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_online_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestOnlineSession _$TestOnlineSessionFromJson(Map<String, dynamic> json) =>
    TestOnlineSession(
      adminID: json['adminID'] as String,
      users: (json['users'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      waitingUsers: (json['waitingUsers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      extraString: json['extraString'] as String? ?? "",
      admitAutomatically: json['admitAutomatically'] as bool? ?? true,
      extraBool: json['extraBool'] as bool? ?? false,
      extraDoubleMap: (json['extraDoubleMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$TestOnlineSessionToJson(TestOnlineSession instance) =>
    <String, dynamic>{
      'adminID': instance.adminID,
      'users': instance.users,
      'waitingUsers': instance.waitingUsers,
      'admitAutomatically': instance.admitAutomatically,
      'extraString': instance.extraString,
      'extraDoubleMap': instance.extraDoubleMap,
      'extraBool': instance.extraBool,
    };
