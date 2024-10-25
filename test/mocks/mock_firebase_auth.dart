import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_user.dart';
import 'mock_user_credential.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  MockFirebaseAuth()
      : _credential = MockUserCredential(),
        _user = MockUser() {
    when(() => _credential.user).thenAnswer((_) => _uid == null ? null : _user);
    when(() => _user.uid).thenAnswer((_) => _uid ?? "");
  }

  String? _uid;
  String? _uidAfterAnonymousSignIn;
  final MockUserCredential _credential;
  final MockUser _user;
  bool _signInCalled = false;

  bool get signInCalled => _signInCalled;

  @override
  Future<UserCredential> signInAnonymously() async {
    _uid = _uidAfterAnonymousSignIn;
    _signInCalled = true;
    return _credential;
  }

  @override
  User? get currentUser => _uid == null ? null : _user;

  void setUserID(String uid) {
    _uid = uid;
  }

  void setUidAfterLogin(String uid) {
    _uidAfterAnonymousSignIn = uid;
  }
}
