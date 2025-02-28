import 'package:firebase_auth/firebase_auth.dart';

import '../model/online_session_base.dart';

extension OnlineSessionBaseExtensions on OnlineSessionBase {
  bool currentUserIsAdmin(User user) {
    return adminID == user.uid;
  }

  bool hasAccess(User user) {
    if (currentUserIsAdmin(user)) return true;

    return users.containsKey(user.uid);
  }

  bool awaitingAccess(User user) {
    return waitingUsers.containsKey(user.uid);
  }

  String getUsernameByID(String uid) {
    if (users.containsKey(uid)) {
      return users[uid]!;
    }
    if (waitingUsers.containsKey(uid)) {
      return waitingUsers[uid]!;
    }
    if (uid == adminID) return "Warden";

    return "Unknown";
  }

  bool isUserParticipating(User user) {
    final uid = user.uid;

    if (users.containsKey(uid)) return true;
    if (adminID == uid) return true;
    if (waitingUsers.containsKey(uid)) return true;

    return false;
  }
}
