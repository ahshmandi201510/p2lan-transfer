import 'package:isar/isar.dart';

part 'app_installation.g.dart';

@collection
class AppInstallation {
  Id id = Isar.autoIncrement;

  String? installationId;

  String? installationWordId;

  bool? firstTimeSetupCompleted;
}
