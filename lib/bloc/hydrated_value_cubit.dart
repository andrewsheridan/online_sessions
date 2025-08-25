import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class HydratedValueCubit<T> extends HydratedCubit<T> {
  final String key;

  HydratedValueCubit(super.state, {this.key = "value"});

  T? valueFromJson(String? json);
  String? valueToJson(T? value);

  void setState(T value) {
    emit(value);
  }

  @override
  T? fromJson(Map<String, dynamic> json) {
    return valueFromJson(json[key]);
  }

  @override
  Map<String, dynamic>? toJson(T? state) {
    return {key: valueToJson(state)};
  }
}
