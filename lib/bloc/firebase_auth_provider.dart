import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final Logger _logger = Logger("FirebaseAuthProvider");
  final FirebaseAuth _instance;

  late final StreamSubscription _userChangedSubscription;

  FirebaseAuthProvider({required FirebaseAuth instance})
      : _instance = instance {
    _userChangedSubscription = _instance.userChanges().listen(
          _handleUserChanged,
        );
  }

  @override
  void dispose() {
    _userChangedSubscription.cancel();
    super.dispose();
  }

  void _handleUserChanged(User? user) {
    notifyListeners();
  }

  User? get currentUser => _instance.currentUser;

  Future<User> ensureLoggedIn() async {
    if (currentUser != null) {
      return currentUser!;
    }

    final cred = await signInAnonymously();
    return cred.user!;
  }

  Future<void> createUserWithEmail(String email, String password) async {
    try {
      await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (ex) {
      _logger.severe(
        "Failed to create user at email address $email.",
        ex,
      );
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (ex) {
      _logger.severe("Failed to log in user $email.", ex);
    }
  }

  // Future<void> googleSignIn() async {
  //   final client = http.Client();
  //   try {
  //     // Trigger the authentication flow
  //     final clientID = ClientId(_clientID);

  //     final credentials = await obtainAccessCredentialsViaUserConsent(
  //       clientID,
  //       ["email"],
  //       client,
  //       (prompt) {
  //         launchUrlString(prompt);
  //       },
  //     );
  //     // Obtain the auth details from the request

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: credentials.accessToken.data,
  //       idToken: credentials.idToken,
  //     );
  //     // Once signed in, return the UserCredential
  //     await _instance.signInWithCredential(credential);

  //     _logger.info("Successfully signed in user.");
  //   } on Exception catch (ex) {
  //     _logger.severe("Failed to log in with google.", ex);
  //   } finally {
  //     client.close();
  //   }
  // }

  Future<UserCredential> signInAnonymously() async {
    try {
      return await _instance.signInAnonymously();
    } catch (ex) {
      _logger.severe("Anonymous sign in failed.", ex);
      rethrow;
    }
  }
}
