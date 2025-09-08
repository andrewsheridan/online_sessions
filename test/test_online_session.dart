import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_sessions/src/model/online_session_base.dart';

part 'test_online_session.freezed.dart';
part 'test_online_session.g.dart';

// @freezed
// class TestOnlineSession extends OnlineSessionBase with _$TestOnlineSession {
//   const factory TestOnlineSession({
//     required String adminID,
//     @Default({}) Map<String, String> users,
//     @Default({}) Map<String, String> waitingUsers,
//     @Default("") String extraString,
//     @Default({}) Map<String, double> extraDoubleMap,
//     @Default(false) bool extraBool,
//     @Default(true) bool admitAutomatically,
//   }) = _TestOnlineSession;

//   factory TestOnlineSession.fromJson(Map<String, dynamic> json) =>
//       _$TestOnlineSessionFromJson(json);
// }

@freezed
@JsonSerializable()
class TestOnlineSession extends OnlineSessionBase with _$TestOnlineSession {
  @override
  final String adminID;
  @override
  final Map<String, String> users;
  @override
  final Map<String, String> waitingUsers;
  @override
  final bool admitAutomatically;
  @override
  final String extraString;
  @override
  final Map<String, double> extraDoubleMap;
  @override
  final bool extraBool;

  TestOnlineSession({
    required this.adminID,
    this.users = const {},
    this.waitingUsers = const {},
    this.extraString = "",
    this.admitAutomatically = true,
    this.extraBool = false,
    this.extraDoubleMap = const {},
  });

  factory TestOnlineSession.fromJson(Map<String, dynamic> json) =>
      _$TestOnlineSessionFromJson(json);

  @override
  Map<String, Object?> toJson() => _$TestOnlineSessionToJson(this);
}
