import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:online_sessions/bloc/online_session_cubit.dart';
import 'package:online_sessions/model/online_session_base.dart';

class MockOnlineSessionCubit<T extends OnlineSessionBase> extends Mock
    implements OnlineSessionCubit<T> {
  final StreamController<T?> _controller = StreamController.broadcast();

  @override
  Stream<T?> get stream => _controller.stream;

  @override
  void emit(T? value) {
    _controller.add(value);
  }
}
