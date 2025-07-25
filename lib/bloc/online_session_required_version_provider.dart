import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:online_sessions/online_sessions.dart';

class OnlineSessionRequiredVersionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final AppVersion installedAppVersion;
  final Logger _logger = Logger("OnlineSessionRequiredVersionProvider");

  late final StreamSubscription _subscription;

  OnlineSessionRequiredVersionProvider({
    required FirebaseFirestore firestore,
    required String appVersionString,
    String versionDocPath = "settings/online_session_required_version",
  })  : _firestore = firestore,
        installedAppVersion = AppVersion.fromString(appVersionString) {
    _subscription = _firestore
        .doc(versionDocPath)
        .snapshots()
        .listen(_onRequiredVersionChanged);
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  AppVersion? _requiredVersion;
  AppVersion? get requiredVersion => _requiredVersion;
  set requiredVersion(AppVersion? value) {
    if (_requiredVersion == value) return;
    _requiredVersion = value;
    notifyListeners();
  }

  bool get updateRequired {
    if (_requiredVersion == null) return false;

    return _requiredVersion! > installedAppVersion;
  }

  void _onRequiredVersionChanged(DocumentSnapshot<Map<String, dynamic>> event) {
    try {
      final data = event.data();

      _logger.info("Required version event received. Data: $data");

      if (!event.exists) {
        _logger.info("No required version set.");
        requiredVersion = null;
        return;
      }

      final requiredVersionString = event.data()?["version"];
      if (requiredVersionString == null) {
        _logger.info("No required version found.");
        requiredVersion = null;
      } else {
        _logger.info("Setting required version to $requiredVersionString");
        requiredVersion = AppVersion.fromString(requiredVersionString);
      }
    } catch (ex) {
      _logger.severe("Failed to update required version from database.", ex);
    }
  }
}
