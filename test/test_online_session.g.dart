// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_online_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestOnlineSessionImpl _$$TestOnlineSessionImplFromJson(
        Map<String, dynamic> json) =>
    _$TestOnlineSessionImpl(
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
      extraDoubleMap: (json['extraDoubleMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      extraBool: json['extraBool'] as bool? ?? false,
    );

Map<String, dynamic> _$$TestOnlineSessionImplToJson(
        _$TestOnlineSessionImpl instance) =>
    <String, dynamic>{
      'adminID': instance.adminID,
      'users': instance.users,
      'waitingUsers': instance.waitingUsers,
      'extraString': instance.extraString,
      'extraDoubleMap': instance.extraDoubleMap,
      'extraBool': instance.extraBool,
    };
