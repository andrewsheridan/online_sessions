// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_online_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestOnlineSession {
  String get adminID;
  Map<String, String> get users;
  Map<String, String> get waitingUsers;
  bool get admitAutomatically;
  String get extraString;
  Map<String, double> get extraDoubleMap;
  bool get extraBool;

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestOnlineSessionCopyWith<TestOnlineSession> get copyWith =>
      _$TestOnlineSessionCopyWithImpl<TestOnlineSession>(
          this as TestOnlineSession, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestOnlineSession &&
            (identical(other.adminID, adminID) || other.adminID == adminID) &&
            const DeepCollectionEquality().equals(other.users, users) &&
            const DeepCollectionEquality()
                .equals(other.waitingUsers, waitingUsers) &&
            (identical(other.admitAutomatically, admitAutomatically) ||
                other.admitAutomatically == admitAutomatically) &&
            (identical(other.extraString, extraString) ||
                other.extraString == extraString) &&
            const DeepCollectionEquality()
                .equals(other.extraDoubleMap, extraDoubleMap) &&
            (identical(other.extraBool, extraBool) ||
                other.extraBool == extraBool));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      adminID,
      const DeepCollectionEquality().hash(users),
      const DeepCollectionEquality().hash(waitingUsers),
      admitAutomatically,
      extraString,
      const DeepCollectionEquality().hash(extraDoubleMap),
      extraBool);

  @override
  String toString() {
    return 'TestOnlineSession(adminID: $adminID, users: $users, waitingUsers: $waitingUsers, admitAutomatically: $admitAutomatically, extraString: $extraString, extraDoubleMap: $extraDoubleMap, extraBool: $extraBool)';
  }
}

/// @nodoc
abstract mixin class $TestOnlineSessionCopyWith<$Res> {
  factory $TestOnlineSessionCopyWith(
          TestOnlineSession value, $Res Function(TestOnlineSession) _then) =
      _$TestOnlineSessionCopyWithImpl;
  @useResult
  $Res call(
      {String adminID,
      Map<String, String> users,
      Map<String, String> waitingUsers,
      String extraString,
      bool admitAutomatically,
      bool extraBool,
      Map<String, double> extraDoubleMap});
}

/// @nodoc
class _$TestOnlineSessionCopyWithImpl<$Res>
    implements $TestOnlineSessionCopyWith<$Res> {
  _$TestOnlineSessionCopyWithImpl(this._self, this._then);

  final TestOnlineSession _self;
  final $Res Function(TestOnlineSession) _then;

  /// Create a copy of TestOnlineSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adminID = null,
    Object? users = null,
    Object? waitingUsers = null,
    Object? extraString = null,
    Object? admitAutomatically = null,
    Object? extraBool = null,
    Object? extraDoubleMap = null,
  }) {
    return _then(TestOnlineSession(
      adminID: null == adminID
          ? _self.adminID
          : adminID // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _self.users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      waitingUsers: null == waitingUsers
          ? _self.waitingUsers
          : waitingUsers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      extraString: null == extraString
          ? _self.extraString
          : extraString // ignore: cast_nullable_to_non_nullable
              as String,
      admitAutomatically: null == admitAutomatically
          ? _self.admitAutomatically
          : admitAutomatically // ignore: cast_nullable_to_non_nullable
              as bool,
      extraBool: null == extraBool
          ? _self.extraBool
          : extraBool // ignore: cast_nullable_to_non_nullable
              as bool,
      extraDoubleMap: null == extraDoubleMap
          ? _self.extraDoubleMap
          : extraDoubleMap // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

// dart format on
