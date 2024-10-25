// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_online_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestOnlineSession _$TestOnlineSessionFromJson(Map<String, dynamic> json) {
  return _TestOnlineSession.fromJson(json);
}

/// @nodoc
mixin _$TestOnlineSession {
  String get adminID => throw _privateConstructorUsedError;
  Map<String, String> get users => throw _privateConstructorUsedError;
  Map<String, String> get waitingUsers => throw _privateConstructorUsedError;
  String get extraString => throw _privateConstructorUsedError;
  Map<String, double> get extraDoubleMap => throw _privateConstructorUsedError;
  bool get extraBool => throw _privateConstructorUsedError;

  /// Serializes this TestOnlineSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestOnlineSessionCopyWith<TestOnlineSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestOnlineSessionCopyWith<$Res> {
  factory $TestOnlineSessionCopyWith(
          TestOnlineSession value, $Res Function(TestOnlineSession) then) =
      _$TestOnlineSessionCopyWithImpl<$Res, TestOnlineSession>;
  @useResult
  $Res call(
      {String adminID,
      Map<String, String> users,
      Map<String, String> waitingUsers,
      String extraString,
      Map<String, double> extraDoubleMap,
      bool extraBool});
}

/// @nodoc
class _$TestOnlineSessionCopyWithImpl<$Res, $Val extends TestOnlineSession>
    implements $TestOnlineSessionCopyWith<$Res> {
  _$TestOnlineSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adminID = null,
    Object? users = null,
    Object? waitingUsers = null,
    Object? extraString = null,
    Object? extraDoubleMap = null,
    Object? extraBool = null,
  }) {
    return _then(_value.copyWith(
      adminID: null == adminID
          ? _value.adminID
          : adminID // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      waitingUsers: null == waitingUsers
          ? _value.waitingUsers
          : waitingUsers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      extraString: null == extraString
          ? _value.extraString
          : extraString // ignore: cast_nullable_to_non_nullable
              as String,
      extraDoubleMap: null == extraDoubleMap
          ? _value.extraDoubleMap
          : extraDoubleMap // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      extraBool: null == extraBool
          ? _value.extraBool
          : extraBool // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestOnlineSessionImplCopyWith<$Res>
    implements $TestOnlineSessionCopyWith<$Res> {
  factory _$$TestOnlineSessionImplCopyWith(_$TestOnlineSessionImpl value,
          $Res Function(_$TestOnlineSessionImpl) then) =
      __$$TestOnlineSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String adminID,
      Map<String, String> users,
      Map<String, String> waitingUsers,
      String extraString,
      Map<String, double> extraDoubleMap,
      bool extraBool});
}

/// @nodoc
class __$$TestOnlineSessionImplCopyWithImpl<$Res>
    extends _$TestOnlineSessionCopyWithImpl<$Res, _$TestOnlineSessionImpl>
    implements _$$TestOnlineSessionImplCopyWith<$Res> {
  __$$TestOnlineSessionImplCopyWithImpl(_$TestOnlineSessionImpl _value,
      $Res Function(_$TestOnlineSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adminID = null,
    Object? users = null,
    Object? waitingUsers = null,
    Object? extraString = null,
    Object? extraDoubleMap = null,
    Object? extraBool = null,
  }) {
    return _then(_$TestOnlineSessionImpl(
      adminID: null == adminID
          ? _value.adminID
          : adminID // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      waitingUsers: null == waitingUsers
          ? _value._waitingUsers
          : waitingUsers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      extraString: null == extraString
          ? _value.extraString
          : extraString // ignore: cast_nullable_to_non_nullable
              as String,
      extraDoubleMap: null == extraDoubleMap
          ? _value._extraDoubleMap
          : extraDoubleMap // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      extraBool: null == extraBool
          ? _value.extraBool
          : extraBool // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestOnlineSessionImpl implements _TestOnlineSession {
  const _$TestOnlineSessionImpl(
      {required this.adminID,
      final Map<String, String> users = const {},
      final Map<String, String> waitingUsers = const {},
      this.extraString = "",
      final Map<String, double> extraDoubleMap = const {},
      this.extraBool = false})
      : _users = users,
        _waitingUsers = waitingUsers,
        _extraDoubleMap = extraDoubleMap;

  factory _$TestOnlineSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestOnlineSessionImplFromJson(json);

  @override
  final String adminID;
  final Map<String, String> _users;
  @override
  @JsonKey()
  Map<String, String> get users {
    if (_users is EqualUnmodifiableMapView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_users);
  }

  final Map<String, String> _waitingUsers;
  @override
  @JsonKey()
  Map<String, String> get waitingUsers {
    if (_waitingUsers is EqualUnmodifiableMapView) return _waitingUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_waitingUsers);
  }

  @override
  @JsonKey()
  final String extraString;
  final Map<String, double> _extraDoubleMap;
  @override
  @JsonKey()
  Map<String, double> get extraDoubleMap {
    if (_extraDoubleMap is EqualUnmodifiableMapView) return _extraDoubleMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extraDoubleMap);
  }

  @override
  @JsonKey()
  final bool extraBool;

  @override
  String toString() {
    return 'TestOnlineSession(adminID: $adminID, users: $users, waitingUsers: $waitingUsers, extraString: $extraString, extraDoubleMap: $extraDoubleMap, extraBool: $extraBool)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestOnlineSessionImpl &&
            (identical(other.adminID, adminID) || other.adminID == adminID) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality()
                .equals(other._waitingUsers, _waitingUsers) &&
            (identical(other.extraString, extraString) ||
                other.extraString == extraString) &&
            const DeepCollectionEquality()
                .equals(other._extraDoubleMap, _extraDoubleMap) &&
            (identical(other.extraBool, extraBool) ||
                other.extraBool == extraBool));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      adminID,
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(_waitingUsers),
      extraString,
      const DeepCollectionEquality().hash(_extraDoubleMap),
      extraBool);

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestOnlineSessionImplCopyWith<_$TestOnlineSessionImpl> get copyWith =>
      __$$TestOnlineSessionImplCopyWithImpl<_$TestOnlineSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestOnlineSessionImplToJson(
      this,
    );
  }
}

abstract class _TestOnlineSession implements TestOnlineSession {
  const factory _TestOnlineSession(
      {required final String adminID,
      final Map<String, String> users,
      final Map<String, String> waitingUsers,
      final String extraString,
      final Map<String, double> extraDoubleMap,
      final bool extraBool}) = _$TestOnlineSessionImpl;

  factory _TestOnlineSession.fromJson(Map<String, dynamic> json) =
      _$TestOnlineSessionImpl.fromJson;

  @override
  String get adminID;
  @override
  Map<String, String> get users;
  @override
  Map<String, String> get waitingUsers;
  @override
  String get extraString;
  @override
  Map<String, double> get extraDoubleMap;
  @override
  bool get extraBool;

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestOnlineSessionImplCopyWith<_$TestOnlineSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
