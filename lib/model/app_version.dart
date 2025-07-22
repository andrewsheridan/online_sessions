import 'package:equatable/equatable.dart';

class AppVersion with EquatableMixin implements Comparable {
  final int major;
  final int minor;
  final int patch;
  final int? build;

  const AppVersion(
    this.major,
    this.minor,
    this.patch, [
    this.build,
  ]);

  factory AppVersion.fromString(String version) {
    final buildSplit = version.split("+");
    final buildNumber =
        buildSplit.length > 1 ? int.tryParse(buildSplit.last) : null;
    final versionsSplit = buildSplit.first.split(".");

    return AppVersion(
      int.parse(versionsSplit[0]),
      int.parse(versionsSplit[1]),
      int.parse(versionsSplit[2]),
      buildNumber,
    );
  }

  @override
  int compareTo(other) {
    if (other is! AppVersion) {
      return 1;
    }

    final majorCompared = major.compareTo(other.major);
    if (majorCompared != 0) return majorCompared;

    final minorCompared = minor.compareTo(other.minor);
    if (minorCompared != 0) return minorCompared;

    final patchCompared = patch.compareTo(other.patch);
    if (patchCompared != 0) return patchCompared;

    final buildCompared = (build ?? 0).compareTo((other.build ?? 0));
    if (buildCompared != 0) return buildCompared;

    return 0;
  }

  @override
  List<Object?> get props => [major, minor, patch, build];
}
