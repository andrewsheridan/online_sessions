import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_auth_provider.dart';

extension OnlineSessionsBuildContextExtensions on BuildContext {
  User? get currentUser => watch<FirebaseAuthProvider>().currentUser;
}
