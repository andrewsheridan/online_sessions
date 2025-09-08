import 'package:online_sessions/online_sessions.dart';

import 'test_online_session.dart';

class OnlineSessionCubit extends OnlineSessionCubitBase<TestOnlineSession> {
  OnlineSessionCubit({
    required super.codeCubit,
    required super.storage,
    required super.firestore,
    required super.auth,
    required super.usernameCubit,
    required super.signOutUser,
    required super.adminNickname,
    required super.sessionFactory,
    required super.fromJsonFactory,
    required super.functions,
  });
}
