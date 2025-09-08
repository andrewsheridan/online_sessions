import 'package:mocktail/mocktail.dart';
import 'package:online_sessions/online_sessions.dart';

class MockValidCodeGenerator extends Mock implements ValidCodeGenerator {
  String _code;
  String? _fallbackCode;

  MockValidCodeGenerator({
    required String code,
    String? fallbackCode,
  })  : _code = code,
        _fallbackCode = fallbackCode;

  void setCode(String value) => _code = value;
  void setFallbackCode(String value) => _fallbackCode = value;

  @override
  Future<String> generateCode(
    int length, {
    Future<bool> Function(String)? isValid,
  }) async {
    if (isValid == null) return Future.value(_code);
    return await isValid(_code)
        ? Future.value(_code)
        : Future.value(_fallbackCode);
  }
}
