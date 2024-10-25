abstract class OnlineSessionBase {
  String get adminID;
  Map<String, String> get users;
  Map<String, String> get waitingUsers;

  OnlineSessionBase({required String adminID});
  Map<String, dynamic> toJson();

  // OnlineSessionBase copyWith({
  //   String? adminID,
  //   Map<String, String>? users,
  //   Map<String, String>? waitingUsers,
  // });
}

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'online_session_base.freezed.dart';
// part 'online_session_base.g.dart';

// @freezed
// class OnlineSessionBase with _$OnlineSessionBase {
//   const factory OnlineSessionBase({
//     required String adminID,
//     @Default({}) Map<String, String> users,
//     @Default({}) Map<String, String> waitingUsers,
//   }) = _OnlineSessionBase;

//   factory OnlineSessionBase.fromJson(Map<String, dynamic> json) =>
//       _$OnlineSessionBaseFromJson(json);
// }
