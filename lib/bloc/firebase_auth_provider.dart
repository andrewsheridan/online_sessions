import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart' as auth_io;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final Logger _logger = Logger("FirebaseAuthProvider");
  final FirebaseAuth _instance;
  final String? _clientID;

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [],
    clientId: _clientID,
  );

  late final StreamSubscription _userChangedSubscription;

  FirebaseAuthProvider({
    required FirebaseAuth instance,
    required String? clientID,
  })  : _instance = instance,
        _clientID = clientID {
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

  // Future<void> createUserWithEmail(String email, String password) async {
  //   try {
  //     await _instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } catch (ex) {
  //     _logger.severe(
  //       "Failed to create user at email address $email.",
  //       ex,
  //     );
  //   }
  // }

  // Future<void> signInWithEmail(String email, String password) async {
  //   try {
  //     await _instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } catch (ex) {
  //     _logger.severe("Failed to log in user $email.", ex);
  //   }
  // }

  Future<UserCredential> googleSignIn() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // googleProvider
        //     .addScope('https://www.googleapis.com/auth/contacts.readonly');
        // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        // Once signed in, return the UserCredential
        final output =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);

        _logger.info("Successfully signed in user via Google.");
        return output;
      } else if (Platform.isWindows) {
        final client = http.Client();
        try {
          // Trigger the authentication flow
          final clientID = auth_io.ClientId(_clientID!);

          final credentials =
              await auth_io.obtainAccessCredentialsViaUserConsent(
            clientID,
            ["email"],
            client,
            (prompt) {
              launchUrlString(prompt);
            },
          );
          // Obtain the auth details from the request

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: credentials.accessToken.data,
            idToken: credentials.idToken,
          );
          // Once signed in, return the UserCredential
          await _instance.signInWithCredential(credential);

          _logger.info("Successfully signed in user.");

          client.close();
        } on Exception catch (ex) {
          _logger.severe("Failed to log in with google.", ex);
          client.close();
          rethrow;
        }
      }
      {
// Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        final output = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        _logger.info("Successfully signed in user via Google.");

        return output;
      }
    } on Exception catch (ex) {
      _logger.severe("Failed to log in via Google.", ex);
      rethrow;
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      final output = await _instance.signInAnonymously();
      _logger.info("Anonymous sign in successful.");
      return output;
    } catch (ex) {
      _logger.severe("Anonymous sign in failed.", ex);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _instance.signOut();
      _logger.info("Sign out successful.");
    } catch (ex) {
      _logger.severe("Sign out failed.");
    }
  }
}
