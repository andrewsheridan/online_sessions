import 'package:cubit_pool/hydrated_value_cubit.dart';

class UsernameCubit extends HydratedValueCubit<String> {
  final String? _storagePrefix;

  UsernameCubit({String initialState = "", String? storagePrefix})
      : _storagePrefix = storagePrefix,
        super(initialState);

  @override
  String get storagePrefix => _storagePrefix ?? super.storagePrefix;

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
