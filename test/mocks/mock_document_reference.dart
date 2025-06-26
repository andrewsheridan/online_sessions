import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_document_snapshot.dart';

// ignore: subtype_of_sealed_class, must_be_immutable
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {
  Map<String, dynamic>? _value;
  late MockDocumentSnapshot _snapshot;
  final StreamController<MockDocumentSnapshot> _controller =
      StreamController.broadcast();

  MockDocumentReference() {
    _snapshot = _createSnapshot();
  }

  Map<String, dynamic>? get internalValue => _value;

  MockDocumentSnapshot _createSnapshot() {
    final snapshot = MockDocumentSnapshot();
    when(() => snapshot.exists).thenAnswer((_) => _value != null);
    when(() => snapshot.data()).thenAnswer((_) => _value);

    return snapshot;
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) =>
      Future.value(_snapshot);

  void setValue(Map<String, dynamic>? value) {
    _value = value;
  }

  @override
  Future<void> set(Map<String, dynamic> value, [SetOptions? options]) async {
    if (options == null || options.merge != true) {
      _value = value;
    } else {
      _value = {...(_value ?? {}), ...value};
    }
    _snapshot = _createSnapshot();
    _controller.add(_snapshot);
  }

  @override
  Stream<MockDocumentSnapshot> snapshots({
    bool includeMetadataChanges = false,
    ListenSource source = ListenSource.defaultSource,
  }) {
    return _controller.stream;
  }

  @override
  Future<void> update(Map<Object, Object?> data) async {
    final updated = {
      if (_value != null) ..._value!,
      for (final item in data.entries) item.key.toString(): item.value,
    };
    _value = updated;
    _snapshot = _createSnapshot();
    _controller.add(_snapshot);
  }
}
