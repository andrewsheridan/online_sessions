import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'hydrated_value_cubit.dart';
import 'valid_code_generator.dart';

class OnlineCodeCubit extends HydratedValueCubit<String?> {
  final ValidCodeGenerator _codeGenerator;
  final FirebaseFirestore _database;
  final String? _storagePrefix;

  OnlineCodeCubit({
    required ValidCodeGenerator codeGenerator,
    required FirebaseFirestore database,
    required bool signOutUser,
    String storagePrefix = "OnlineCodeCubit",
    String? state,
  })  : _codeGenerator = codeGenerator,
        _database = database,
        _storagePrefix = storagePrefix,
        super(state) {
    if (kDebugMode && signOutUser) {
      emit(null);
    }
  }

  @override
  String get storagePrefix => _storagePrefix ?? super.storagePrefix;

  void setCode(String? code) {
    emit(code);
  }

  Future<String> generateCode() async {
    final code = await _codeGenerator.generateCode(6, isValid: (code) async {
      final ref = _database.collection("sessions").doc(code);
      final snapshot = await ref.get();
      return !snapshot.exists;
    });

    emit(code);

    return code;
  }

  @override
  String? valueFromJson(String? json) {
    return json;
  }

  @override
  String? valueToJson(String? value) {
    return value;
  }
}
