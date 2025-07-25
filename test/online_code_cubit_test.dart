import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_sessions/bloc/online_code_cubit.dart';
import 'package:online_sessions/bloc/valid_code_generator.dart';

import 'mocks/mock_code_generator.dart';
import 'mocks/mock_collection_reference.dart';
import 'mocks/mock_document_reference.dart';
import 'mocks/mock_firebase_firestore.dart';
import 'mocks/mock_hydrated_storage.dart';

void main() {
  late ValidCodeGenerator validCodeGenerator;
  late MockFirebaseFirestore database;
  late MockCollectionReference collection;
  late MockDocumentReference doc;
  late MockCodeGenerator codeGenerator;
  late MockStorage storage;

  setUp(() {
    storage = MockStorage();
    HydratedBloc.storage = storage;

    codeGenerator = MockCodeGenerator();
    validCodeGenerator = ValidCodeGenerator(codeGenerator: codeGenerator);
    database = MockFirebaseFirestore();
    collection = MockCollectionReference();
    doc = MockDocumentReference();

    when(() => database.collection(any())).thenReturn(collection);
    when(() => collection.doc(any())).thenReturn(doc);
    doc.set(null);
    when(() => storage.write(any(), any())).thenAnswer(
      (_) => Future.value(),
    );
  });

  OnlineCodeCubit build() => OnlineCodeCubit(
        codeGenerator: validCodeGenerator,
        database: database,
        signOutUser: false,
      );

  test(
    "Generating a new code which does not yet exist.",
    () async {
      const expectedCode = "123456";
      when(() => codeGenerator.generate(6)).thenReturn(expectedCode);
      final codeCubit = build();
      final code = await codeCubit.generateCode();
      expect(code, expectedCode);
      expect(codeCubit.state, expectedCode);
    },
  );

  test(
    "Generating a new code which already exists causes another to be made.",
    () async {
      var index = 0;
      final codes = ["123456", "ABCDEF"];

      doc.set({});
      final emptyDoc = MockDocumentReference();

      when(() => collection.doc("123456")).thenReturn(doc);
      when(() => collection.doc("ABCDEF")).thenReturn(emptyDoc);

      when(() => codeGenerator.generate(6)).thenAnswer((_) {
        final value = codes[index];
        index++;
        return value;
      });

      final codeCubit = build();
      final code = await codeCubit.generateCode();
      expect(code, "ABCDEF");
      expect(codeCubit.state, "ABCDEF");
    },
  );

  test("Clearing the state", () async {
    const expectedCode = "123456";
    when(() => codeGenerator.generate(6)).thenReturn(expectedCode);
    final codeCubit = build();
    final code = await codeCubit.generateCode();
    expect(code, expectedCode);
    expect(codeCubit.state, expectedCode);

    codeCubit.setCode(null);

    expect(codeCubit.state, null);
  });
}
