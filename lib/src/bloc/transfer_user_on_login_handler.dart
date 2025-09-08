import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:online_sessions/online_sessions.dart';

class TransferUserOnLoginHandler extends ChangeNotifier {
  final OnlineSessionCubitBase _onlineSessionCubit;
  final OnlineCodeCubit _onlineCodeCubit;
  final FirebaseFunctions _functions;
  final FirebaseAuthProvider _firebaseAuthProvider;
  final Logger _logger = Logger("TransferUserOnLoginHandler");

  User? _previousUser;

  TransferUserOnLoginHandler({
    required OnlineSessionCubitBase onlineSessionCubit,
    required OnlineCodeCubit onlineCodeCubit,
    required FirebaseFunctions functions,
    required FirebaseAuthProvider firebaseAuthProvider,
  })  : _onlineSessionCubit = onlineSessionCubit,
        _functions = functions,
        _firebaseAuthProvider = firebaseAuthProvider,
        _onlineCodeCubit = onlineCodeCubit {
    _previousUser = _firebaseAuthProvider.currentUser;
    _firebaseAuthProvider.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _firebaseAuthProvider.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() async {
    final user = _firebaseAuthProvider.currentUser;
    if (_previousUser?.uid == user?.uid) return;

    final previousUser = _previousUser;

    _previousUser = user;

    if (previousUser == null || user == null) return;

    final session = _onlineSessionCubit.state;

    if (session == null) return;

    if (!session.isUserParticipating(previousUser)) return;

    if (!previousUser.isAnonymous) return;

    final code = _onlineCodeCubit.state;

    _logger.info(
      "Transfering user from ${previousUser.uid} to ${user.uid} with code $code.",
    );

    try {
      final callable = _functions.httpsCallable("transferOnlineSessionUserID");

      await callable({
        "oldUserID": previousUser.uid,
        "newUserID": user.uid,
        "onlineSessionCode": code,
      });
    } on FirebaseFunctionsException catch (ex) {
      _logger.severe("Failed to transfer user.", ex);
      _logger.severe(ex.message);
      _logger.severe(ex.code);
      _logger.severe(ex.details);
    }
  }
}
