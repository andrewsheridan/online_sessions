import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_sessions/online_sessions.dart';

import 'mocks/mock_document_reference.dart';
import 'mocks/mock_firebase_firestore.dart';

void main() {
  late MockFirebaseFirestore firestore;
  late MockDocumentReference documentReference;
  // late MockDocumentSnapshot snapshot;
  // late StreamController<MockDocumentSnapshot> requiredVersionController;
  const requiredVersionKey = "required_version";

  setUp(() {
    firestore = MockFirebaseFirestore();
    documentReference = MockDocumentReference();
    // snapshot = MockDocumentSnapshot();
    // requiredVersionController = StreamController<MockDocumentSnapshot>();

    when(() => firestore.doc(requiredVersionKey))
        .thenAnswer((_) => documentReference);
  });

  void setUpRequiredVersion(String? requiredVersion) {
    documentReference.update({"version": requiredVersion});
  }

  OnlineSessionRequiredVersionProvider build(String appVersion) =>
      OnlineSessionRequiredVersionProvider(
        firestore: firestore,
        appVersionString: appVersion,
        versionKey: requiredVersionKey,
      );

  test(
    "Required Version & Update Required",
    () async {
      setUpRequiredVersion(null);

      final updateHandler = build("1.0.1");
      expect(updateHandler.updateRequired, false);
      expect(updateHandler.installedAppVersion, AppVersion(1, 0, 1));
      expect(updateHandler.requiredVersion, null);

      setUpRequiredVersion("1.0.0");
      await pumpEventQueue();
      expect(updateHandler.updateRequired, false);
      expect(updateHandler.requiredVersion, AppVersion(1, 0, 0));

      setUpRequiredVersion("1.0.1");
      await pumpEventQueue();
      expect(updateHandler.updateRequired, false);
      expect(updateHandler.requiredVersion, AppVersion(1, 0, 1));

      setUpRequiredVersion("1.0.2");
      await pumpEventQueue();
      expect(updateHandler.updateRequired, true);
      expect(updateHandler.requiredVersion, AppVersion(1, 0, 2));

      setUpRequiredVersion("1.1.0");
      await pumpEventQueue();
      expect(updateHandler.updateRequired, true);
      expect(updateHandler.requiredVersion, AppVersion(1, 1, 0));

      setUpRequiredVersion("2.0.0");
      await pumpEventQueue();
      expect(updateHandler.updateRequired, true);
      expect(updateHandler.requiredVersion, AppVersion(2, 0, 0));

      setUpRequiredVersion(null);
      await pumpEventQueue();
      expect(updateHandler.updateRequired, false);
      expect(updateHandler.requiredVersion, null);
    },
  );
}
