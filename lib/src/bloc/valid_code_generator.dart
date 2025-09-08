import 'code_generator.dart';

class ValidCodeGenerator {
  final CodeGenerator codeGenerator;

  ValidCodeGenerator({required this.codeGenerator});

  Future<String> generateCode(
    int length, {
    Future<bool> Function(String)? isValid,
  }) async {
    var output = codeGenerator.generate(length);
    if (isValid == null) return Future.value(output);
    return await isValid(output)
        ? Future.value(output)
        : generateCode(length, isValid: isValid);
  }
}
