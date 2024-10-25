import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

MockStorage buildMockStorage(Map<String, dynamic>? initialState) {
  final storage = MockStorage();
  when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
  when(() => storage.read(any())).thenReturn(initialState ?? {});
  return storage;
}
