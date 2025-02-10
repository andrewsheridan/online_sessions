import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final Logger _logger = Logger("FirebaseAuthProvider");
  final FirebaseAuth _firebaseAuth;
  final String? _clientID;

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [],
    clientId: _clientID,
  );

  late final StreamSubscription _userChangedSubscription;

  FirebaseAuthProvider(
      {required FirebaseAuth instance, required String? clientID, i})
      : _firebaseAuth = instance,
        _clientID = clientID {
    _userChangedSubscription = _firebaseAuth.userChanges().listen(
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

  User? get currentUser => _firebaseAuth.currentUser;

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
        final output = await _firebaseAuth.signInWithPopup(googleProvider);

        _logger.info("Successfully signed in user via Google.");
        return output;
      } else {
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
        final output = await _firebaseAuth.signInWithCredential(
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
      final output = await _firebaseAuth.signInAnonymously();
      _logger.info("Anonymous sign in successful.");
      return output;
    } catch (ex) {
      _logger.severe("Anonymous sign in failed.", ex);
      rethrow;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      if (kIsWeb) {
        await _firebaseAuth.signInWithPopup(appleProvider);
      } else if (Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
        await _firebaseAuth.signInWithProvider(appleProvider);
      } else {
        // Pulled from https://dev.to/offlineprogrammer/flutter-firebase-authentication-apple-sign-in-1m64

        // To prevent replay attacks with the credential returned from Apple, we
        // include a nonce in the credential request. When signing in in with
        // Firebase, the nonce in the id token returned by Apple, is expected to
        // match the sha256 hash of `rawNonce`.
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
        // Request credential for the currently signed in Apple account.
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Create an `OAuthCredential` from the credential returned by Apple.
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        // Sign in the user with Firebase. If the nonce we generated earlier does
        // not match the nonce in `appleCredential.identityToken`, sign in will fail.
        await _firebaseAuth.signInWithCredential(oauthCredential);
      }
    } catch (exception) {
      _logger.severe("Failed to login with Apple.", exception);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _logger.info("Sign out successful.");
    } catch (ex) {
      _logger.severe("Sign out failed.");
    }
  }
}
