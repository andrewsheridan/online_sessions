import 'package:cubit_pool/hydrated_value_cubit.dart';

class UsernameCubit extends HydratedValueCubit<String> {
  UsernameCubit({String initialState = ""}) : super(initialState);

  void setUsername(String username) {
    emit(username);
  }

  @override
  String? valueFromJson(String? json) {
    return json ?? "";
  }

  @override
  String? valueToJson(String? value) {
    return value;
  }
}
