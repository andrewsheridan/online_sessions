import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

import '../model/online_session_base.dart';
import 'online_code_cubit.dart';
import 'username_cubit.dart';

abstract class OnlineSessionCubitBase<T extends OnlineSessionBase>
    extends Cubit<T?> {
  final OnlineCodeCubit _codeCubit;
  @protected
  final FirebaseAuth auth;
  final FirebaseStorage _storage;
  final FirebaseFunctions _functions;
  final CollectionReference _sessionsRef;
  // final FirebaseFirestore _firestore;
  final Logger _logger = Logger("OnlineSessionCubit");
  final UsernameCubit _usernameCubit;
  final String adminNickname;
  final T Function({required String adminID}) sessionFactory;
  final T Function(Map<String, dynamic> json) fromJsonFactory;

  final _connectedToSessionController = StreamController<T>.broadcast();
  Stream<T> get connectedToSessionStream =>
      _connectedToSessionController.stream;

  final _userRemovedController = StreamController<String>.broadcast();
  Stream<String> get userRemovedStream => _userRemovedController.stream;

  DocumentReference? _currentSessionRef;
  Reference? _sessionStorageRef;

  StreamSubscription? _subscription;

  OnlineSessionCubitBase({
    required OnlineCodeCubit codeCubit,
    required FirebaseStorage storage,
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
    required this.auth,
    required UsernameCubit usernameCubit,
    required bool signOutUser,
    required this.adminNickname,
    required this.sessionFactory,
    required this.fromJsonFactory,
  })  : _codeCubit = codeCubit,
        _sessionsRef = firestore.collection("sessions"),
        _usernameCubit = usernameCubit,
        _storage = storage,
        _functions = functions,
        super(null) {
    if (signOutUser) {
      emit(null);
    } else if (_codeCubit.state != null) {
      _connectToSession(_codeCubit.state!, _usernameCubit.state);
    }
  }

  @override
  Future<void> close() {
    _connectedToSessionController.close();
    _userRemovedController.close();
    return super.close();
  }

  Reference? get sessionStorageRef => _sessionStorageRef;

  @mustCallSuper
  Future<String> createSession() async {
    try {
      if (currentUserIsAdmin) {
        await _currentSessionRef?.delete();
      }

      final user = await ensureLoggedIn();
      final code = await _codeCubit.generateCode();
      _currentSessionRef = _sessionsRef.doc(code);

      set(
        sessionFactory(adminID: user.uid).toJson(),
        SetOptions(merge: true),
      );

      await _connectToSession(code, adminNickname);

      await Clipboard.setData(ClipboardData(text: code));

      return code;
    } catch (ex) {
      _logger.severe("Failed to create online session.", ex);
      rethrow;
    }
  }

  @mustCallSuper
  Future<void> joinSession(String code, String username) async {
    try {
      await ensureLoggedIn();
      _codeCubit.setCode(code.toUpperCase());
      _usernameCubit.setUsername(username);

      final callable = _functions.httpsCallable("joinSession");
      await callable({"username": username, "onlineSessionCode": code});

      final session = await _connectToSession(code.toUpperCase(), username);

      if (session == null) {
        final message = "Session with code $code not found.";
        _logger.severe(message);
        throw message;
      }
    } catch (ex) {
      _logger.severe("Failed to join session.", ex);
      rethrow;
    }
  }

  Future<void> setAdmitAutomatically(bool admitAutomatically) async {
    return update({"admitAutomatically": admitAutomatically});
  }

  Future<User> ensureLoggedIn() async {
    if (auth.currentUser != null) return auth.currentUser!;
    try {
      final credential = await auth.signInAnonymously();
      return credential.user!;
    } catch (ex) {
      _logger.severe("Failed to log in anonymous user.");
      rethrow;
    }
  }

  Future<T?> _getCurrentSessionState(String code) async {
    final currentState = await _currentSessionRef!.get();
    if (!currentState.exists) {
      return null;
    }

    return _parseSnapshot(currentState);
  }

  @mustCallSuper
  Future<void> disconnectFromSession() async {
    if (_sessionStorageRef == null) {
      _logger.warning("No storage reference found, cannot clear images.");
      return;
    }

    if (currentUserIsAdmin) {
      try {
        final list = await _sessionStorageRef!.listAll();
        for (final item in list.items) {
          item.delete();
        }
      } catch (ex) {
        _logger.warning("Failed to delete images for session on disconnect.");
      }

      _currentSessionRef?.delete();
    } else {
      await removeUser(auth.currentUser!.uid);
    }

    await _codeCubit.clear();
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }

    emit(null);
  }

  void _checkForUserAdmitted(T? updated) {
    final user = auth.currentUser;
    if (user == null) return;
    if (updated == null) return;

    if ((state?.users ?? {}).containsKey(user.uid)) return;

    if (updated.users.containsKey(user.uid)) {
      _connectedToSessionController.add(updated);
    }
  }

  /// Sets the current code,
  Future<T?> _connectToSession(String code, String username) async {
    await ensureLoggedIn();
    _subscription?.cancel();
    _currentSessionRef = _sessionsRef.doc(code);
    _sessionStorageRef = _storage.ref("sessions/$code");

    final session = await _getCurrentSessionState(code);

    _checkForUserAdmitted(session);
    emit(session);

    if (session == null) {
      _codeCubit.setCode(null);
    } else {
      _subscription = _currentSessionRef!.snapshots().listen((value) {
        final snapshot = _parseSnapshot(value);
        _checkForUserAdmitted(snapshot);
        emit(snapshot);
      });
    }

    return session;
  }

  T? _parseSnapshot(DocumentSnapshot snapshot) {
    try {
      if (!snapshot.exists) {
        return null;
      } else {
        final map = snapshot.data() as Map<String, dynamic>;
        final session = fromJsonFactory(map);
        return session;
      }
    } catch (ex) {
      _logger.severe("Failed to parse session.", ex);
    }
    return null;
  }

  @mustCallSuper
  void admitUser(String userID) {
    final currentState = state!;
    final username = currentState.waitingUsers[userID]!;

    update(
      {
        "waitingUsers.$userID": FieldValue.delete(),
      },
    );

    set(
      {
        "users": {
          userID: username,
        },
      },
      SetOptions(merge: true),
    );
  }

  @mustCallSuper
  Future<void> removeUser(String userID) async {
    await update(
      {
        "waitingUsers.$userID": FieldValue.delete(),
        "users.$userID": FieldValue.delete(),
      },
    );

    _userRemovedController.add(userID);
  }

  Future<void> update(Map<Object, Object?> data) async {
    return _currentSessionRef?.update(
      <Object, Object?>{
        ...data,
        "timestamp": FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> set(Object? data, [SetOptions? options]) async {
    if (data is Map) {
      return _currentSessionRef?.set(
        <String, dynamic>{
          ...data,
          "timestamp": FieldValue.serverTimestamp(),
        },
        options,
      );
    } else {
      return _currentSessionRef?.set(
        data,
        options,
      );
    }
  }

  bool get currentUserIsAdmin {
    return state != null && auth.currentUser?.uid == state!.adminID;
  }

  bool get hasAccess {
    if (currentUserIsAdmin) return true;
    if (state == null) return false;
    final currentUser = auth.currentUser;
    if (currentUser == null) return false;
    return state!.users.containsKey(currentUser.uid);
  }

  bool get awaitingAccess {
    if (state == null) return false;
    final currentUser = auth.currentUser;
    if (currentUser == null) return false;
    if (state!.adminID == currentUser.uid) return false;
    return state!.waitingUsers.containsKey(currentUser.uid);
  }
}
