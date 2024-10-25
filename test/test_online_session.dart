import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_sessions/model/online_session_base.dart';

part 'test_online_session.freezed.dart';
part 'test_online_session.g.dart';

@freezed
class TestOnlineSession extends OnlineSessionBase with _$TestOnlineSession {
  const factory TestOnlineSession({
    required String adminID,
    @Default({}) Map<String, String> users,
    @Default({}) Map<String, String> waitingUsers,
    @Default("") String extraString,
    @Default({}) Map<String, double> extraDoubleMap,
    @Default(false) bool extraBool,
  }) = _TestOnlineSession;

  factory TestOnlineSession.fromJson(Map<String, dynamic> json) =>
      _$TestOnlineSessionFromJson(json);
}
