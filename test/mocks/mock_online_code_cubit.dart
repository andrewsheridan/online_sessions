import 'package:mocktail/mocktail.dart';
import 'package:online_sessions/bloc/online_code_cubit.dart';

class MockOnlineCodeCubit extends Mock implements OnlineCodeCubit {
  String? _code;

  final String codeToGenerate;

  MockOnlineCodeCubit(this.codeToGenerate);

  @override
  String? get state => _code;

  @override
  void setCode(String? code) {
    _code = code;
  }

  @override
  Future<String> generateCode() async {
    return codeToGenerate;
  }
}
