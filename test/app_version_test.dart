import 'package:flutter_test/flutter_test.dart';
import 'package:online_sessions/model/app_version.dart';

void main() {
  final testCases = {
    "1.0.0": AppVersion(1, 0, 0),
    "1.0.0+1": AppVersion(1, 0, 0, 1),
    "1.0.1": AppVersion(1, 0, 1),
    "1.0.1+1": AppVersion(1, 0, 1, 1),
    "1.0.2": AppVersion(1, 0, 2),
    "1.1.0": AppVersion(1, 1, 0),
    "1.1.0+1": AppVersion(1, 1, 0, 1),
    "1.1.1": AppVersion(1, 1, 1),
    "2.0.0": AppVersion(2, 0, 0),
    "2.0.0+1": AppVersion(2, 0, 0, 1),
    "2.0.1": AppVersion(2, 0, 1),
    "2.0.1+1": AppVersion(2, 0, 1, 1),
    "2.1.0": AppVersion(2, 1, 0),
    "2.1.0+1": AppVersion(2, 1, 0, 1),
    "2.1.1": AppVersion(2, 1, 1),
    "2.1.1+1": AppVersion(2, 1, 1, 1),
  };

  group("AppVersion.fromString()", () {
    for (final testCase in testCases.entries) {
      test(
        testCase.key,
        () {
          expect(AppVersion.fromString(testCase.key), testCase.value);
        },
      );
    }
  });

  group("Comparing App Versions", () {
    final keyList = testCases.keys.toList();
    for (int currentIndex = 0;
        currentIndex < testCases.length;
        currentIndex++) {
      final currentKey = keyList[currentIndex];
      final currentValue = testCases[currentKey]!;
      for (int compareAgainstIndex = 0;
          compareAgainstIndex <= currentIndex;
          compareAgainstIndex++) {
        final compareAgainstKey = keyList[compareAgainstIndex];
        final compareAgainstValue = testCases[compareAgainstKey]!;
        if (compareAgainstIndex == currentIndex) {
          test(
            "$currentKey == $compareAgainstKey",
            () {
              expect(currentValue, compareAgainstValue);
            },
          );
        } else {
          test("$currentKey > $compareAgainstKey", () {
            expect(currentValue.compareTo(compareAgainstValue), 1);
          });
        }
      }
    }
  });
}
