import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:online_sessions/online_sessions.dart';

enum OnlineSessionStatus { inactive, active, done, error }

class OnlineSessionStatusProvider extends ChangeNotifier {
  final OnlineSessionCubitBase _onlineSessionCubit;
  final Logger _logger = Logger("OnlineSessionStatusProvider");
  final Level logLevel;
  late final StreamSubscription _dataSubscription;
  late final StreamSubscription _onDoneSubscription;
  late final StreamSubscription _onErrorSubscription;

  OnlineSessionStatusProvider({
    required OnlineSessionCubitBase onlineSessionCubit,
    required this.logLevel,
  }) : _onlineSessionCubit = onlineSessionCubit {
    _onlineSessionCubit.stream.listen(_onStreamData);
    _onlineSessionCubit.snapshotDoneStream.listen(_onSnapshotDone);
    _onlineSessionCubit.snapshotErrorStream.listen(_onSnapshotError);

    _status = _onlineSessionCubit.state == null
        ? OnlineSessionStatus.inactive
        : OnlineSessionStatus.active;
  }

  @override
  void dispose() {
    _dataSubscription.cancel();
    _onDoneSubscription.cancel();
    _onErrorSubscription.cancel();
    super.dispose();
  }

  OnlineSessionStatus _status = OnlineSessionStatus.inactive;

  OnlineSessionStatus get status => _status;
  void _setStatus(OnlineSessionStatus status) {
    if (_status == status) return;

    _logger.log(logLevel, "Status set to ${status.name}.");
    _status = status;
    notifyListeners();
  }

  void _onStreamData(OnlineSessionBase? event) {
    if (event == null) {
      _setStatus(OnlineSessionStatus.inactive);
    } else {
      _setStatus(OnlineSessionStatus.active);
    }
  }

  void _onSnapshotDone(void event) {
    _setStatus(OnlineSessionStatus.done);
  }

  void _onSnapshotError(SnapshotError event) {
    _setStatus(OnlineSessionStatus.error);
  }
}
