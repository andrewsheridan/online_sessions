import 'package:online_sessions/bloc/online_session_cubit_base.dart';

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
