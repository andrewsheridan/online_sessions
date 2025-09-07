import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mock_collection_reference.dart';
import 'mocks/mock_document_reference.dart';
import 'mocks/mock_firebase_auth.dart';
import 'mocks/mock_firebase_firestore.dart';
import 'mocks/mock_firebase_functions.dart';
import 'mocks/mock_firebase_storage.dart';
import 'mocks/mock_https_callable.dart';
import 'mocks/mock_online_code_cubit.dart';
import 'mocks/mock_username_cubit.dart';
import 'online_session_cubit.dart';
import 'test_online_session.dart';

void main() {
  const code = "123456";
  const wardenID = "admin_id";
  const noAccessID = "no_access_id";
  const waitingAccessID = "waiting_access_id";
  const hasAccessID = "has_access_id";
  const waitingAccessName = "waiting_access_name";
  const hasAccessName = "has_access_name";
  TestOnlineSession sessionData = TestOnlineSession(
    adminID: wardenID,
    users: {hasAccessID: hasAccessName},
    waitingUsers: {waitingAccessID: waitingAccessName},
    admitAutomatically: true,
  );

  late MockOnlineCodeCubit onlineCodeCubit;
  late MockFirebaseAuth auth;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference sessionsRef;
  late MockDocumentReference currentSessionRef;
  late MockUsernameCubit usernameCubit;
  late MockFirebaseStorage storage;
  late MockReference storageReference;
  late MockListResult listResult;
  late MockFirebaseFunctions functions;
  late MockHttpsCallable callable;
  late MockHttpsCallableResult callableResult;

  bool admitAutomatically;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();

    onlineCodeCubit = MockOnlineCodeCubit(code);
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFirestore();
    sessionsRef = MockCollectionReference();
    currentSessionRef = MockDocumentReference();
    usernameCubit = MockUsernameCubit();
    storage = MockFirebaseStorage();
    storageReference = MockReference();
    listResult = MockListResult();
    functions = MockFirebaseFunctions();
    callable = MockHttpsCallable();
    callableResult = MockHttpsCallableResult();

    admitAutomatically = true;

    when(() => firestore.collection("sessions")).thenReturn(sessionsRef);
    when(() => sessionsRef.doc(code)).thenReturn(currentSessionRef);
    when(() => usernameCubit.state).thenReturn("Andrew");
    when(() => storage.ref(any())).thenReturn(storageReference);
    when(() => storageReference.listAll()).thenAnswer((_) async => listResult);
    when(() => listResult.items).thenReturn([]);
    when(() => functions.httpsCallable("joinSession")).thenReturn(callable);
    when(() => callable.call(any())).thenAnswer((invocation) async {
      final username = invocation.positionalArguments.first["username"];
      // final code = invocation.positionalArguments.first["onlineSessionCode"];
      final uid = auth.currentUser!.uid;
      final currentSession = currentSessionRef.internalValue == null
          ? sessionData
          : TestOnlineSession.fromJson(currentSessionRef.internalValue!);
      if (admitAutomatically) {
        currentSessionRef.set(currentSession.copyWith(
          users: {...sessionData.users, uid: username},
          admitAutomatically: true,
        ).toJson());
      } else {
        currentSessionRef.set(currentSession.copyWith(
          waitingUsers: {...sessionData.waitingUsers, uid: username},
          admitAutomatically: false,
        ).toJson());
      }
      return callableResult;
    });
  });

  OnlineSessionCubit build({bool signOutUser = false}) => OnlineSessionCubit(
        codeCubit: onlineCodeCubit,
        firestore: firestore,
        auth: auth,
        usernameCubit: usernameCubit,
        storage: storage,
        functions: functions,
        signOutUser: signOutUser,
        adminNickname: "Lord Ruler",
        sessionFactory: ({required adminID, required code}) =>
            TestOnlineSession(adminID: adminID),
        fromJsonFactory: (Map<String, dynamic> data) {
          return TestOnlineSession.fromJson(data);
        },
      );

  void setupCode() {
    onlineCodeCubit.setCode(code);
  }

  blocTest(
    "Given there is no current code, when constructed, do not attempt any connections.",
    build: build,
    act: (cubit) async {},
    verify: (bloc) {
      expect(bloc.state, null);
    },
  );

  blocTest(
    "Given there is a current code but no matching online session, when constructed, then clear the code and do not connect.",
    setUp: () {
      setupCode();
      currentSessionRef.set(null);
      auth.setUidAfterLogin(wardenID);
    },
    build: build,
    verify: (bloc) {
      expect(auth.signInCalled, true);
      expect(onlineCodeCubit.state, null);
    },
  );

  blocTest(
    "Given there is a current code, when constructed, connect to the online session.",
    setUp: () {
      currentSessionRef.set(sessionData.toJson());
      setupCode();
      auth.setUserID(wardenID);
    },
    build: build,
    expect: () => [
      sessionData,
    ],
    verify: (bloc) {
      expect(auth.signInCalled, false);
    },
  );

  blocTest(
    "Given the user has not yet been signed in, when a connection is attempted, then the user will be signed in anonymously.",
    setUp: () {
      setupCode();
      auth.setUidAfterLogin(wardenID);
    },
    build: build,
    verify: (bloc) {
      expect(auth.signInCalled, true);
      expect(auth.currentUser?.uid, wardenID);
    },
  );

  blocTest(
    "Given the user is already signed in, when a connection is attempted, then the user will remain signed in with the previous ID.",
    setUp: () {
      setupCode();
      auth.setUserID(wardenID);
    },
    build: build,
    verify: (bloc) {
      expect(auth.signInCalled, false);
    },
  );

  blocTest(
    "Given the user is the warden of the session, when connected to the session, isWarden will be true.",
    setUp: () {
      currentSessionRef.set(sessionData.toJson());
      setupCode();
      auth.setUidAfterLogin(wardenID);
    },
    build: build,
    verify: (bloc) {
      expect(bloc.currentUserIsAdmin, true);
      expect(bloc.hasAccess, true);
      expect(bloc.awaitingAccess, false);
    },
  );

  blocTest(
    "Given the user is not the warden of the session, when connected to the session, isWarden will be false.",
    setUp: () {
      setupCode();
      currentSessionRef.set(sessionData.toJson());
      auth.setUserID(noAccessID);
    },
    build: build,
    verify: (bloc) {
      expect(bloc.currentUserIsAdmin, false);
      expect(bloc.hasAccess, false);
      expect(bloc.awaitingAccess, false);
    },
  );

  blocTest(
    "Given the user is waiting for access, when connected to the session, awaitingAccess will be true.",
    setUp: () {
      setupCode();
      currentSessionRef.set(sessionData.toJson());
      auth.setUserID(waitingAccessID);
    },
    build: build,
    verify: (bloc) {
      expect(bloc.currentUserIsAdmin, false);
      expect(bloc.hasAccess, false);
      expect(bloc.awaitingAccess, true);
    },
  );

  blocTest(
    "Given there is no current code when constructed, when createSession is called, then a code is generated and a new session created where the current user is the admin.",
    setUp: () {
      auth.setUserID(hasAccessID);
    },
    build: build,
    act: (bloc) async {
      await bloc.createSession();
    },
    expect: () => [TestOnlineSession(adminID: hasAccessID)],
    verify: (bloc) {
      expect(bloc.currentUserIsAdmin, true);
      expect(bloc.hasAccess, true);
      expect(bloc.awaitingAccess, false);
    },
  );

  blocTest(
    "Given a user has not yet been invited to an existing session and automatically admit is false, when a user joins a session with a code, then their ID will be added to the list of waiting.",
    setUp: () {
      admitAutomatically = false;
      currentSessionRef.set(
        TestOnlineSession(
          adminID: wardenID,
          users: {},
          admitAutomatically: false,
          waitingUsers: {},
        ).toJson(),
      );
      auth.setUidAfterLogin(waitingAccessID);
    },
    build: build,
    act: (bloc) async {
      await bloc.joinSession(code, waitingAccessName);
      await pumpEventQueue();
    },
    expect: () => [
      TestOnlineSession(
        adminID: wardenID,
        waitingUsers: {waitingAccessID: waitingAccessName},
        admitAutomatically: false,
      ),
    ],
  );

  blocTest(
    "Given a user has not yet been invited to an existing session and automatically admit is true, when a user joins a session with a code, then their ID will be added to the list of users.",
    setUp: () {
      admitAutomatically = true;
      currentSessionRef.set(
        TestOnlineSession(
          adminID: wardenID,
          users: {},
          admitAutomatically: true,
          waitingUsers: {},
        ).toJson(),
      );
      auth.setUidAfterLogin(hasAccessID);
    },
    build: build,
    act: (bloc) async {
      await bloc.joinSession(code, hasAccessName);
      await pumpEventQueue();
    },
    expect: () => [
      TestOnlineSession(
        adminID: wardenID,
        users: {hasAccessID: hasAccessName},
      ),
    ],
  );

  blocTest(
    "Given a user is connected to a session, when the session state changes, then that change will be reflected in the cubit.",
    setUp: () {
      setupCode();
      currentSessionRef.set(
        TestOnlineSession(adminID: wardenID).toJson(),
      );
      auth.setUserID(wardenID);
    },
    build: build,
    act: (bloc) {
      currentSessionRef.set(sessionData.toJson());
    },
    expect: () => [sessionData],
  );
}
