import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:permission_handler/permission_handler.dart';

import 'platforms.dart';

class ExternalPathService {
  const ExternalPathService();

  Future<String?> getPathOfDirectory() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      return FilePicker.platform.getDirectoryPath();
    }

    if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return getDirectoryPath();
    }
    return null;
  }

  Future<String?> getPathOfFile() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      return (await FilePicker.platform.pickFiles(
        allowMultiple: false,
      ))?.files.firstOrNull?.path;
    }

    if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return (await openFile())?.path;
    }
    return null;
  }

  Future<List<String>> getPathsOfFiles() async {
    if (Platforms.isMobile && await _androidPermissionsGranted()) {
      final filePickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (filePickerResult == null) {
        return [];
      }

      return filePickerResult.files
          .map((e) => XFile(e.path!))
          .map((e) => e.path)
          .toList();
    } else if (Platforms.isMacOS || Platforms.isLinux || Platforms.isWindows) {
      return (await openFiles()).map((e) => e.path).toList();
    }
    return [];
  }

  Future<bool> _androidPermissionsGranted() async =>
      (await Permission.audio
              .onDeniedCallback(() {})
              .onGrantedCallback(() {})
              .onPermanentlyDeniedCallback(() {})
              .onRestrictedCallback(() {})
              .onLimitedCallback(() {})
              .onProvisionalCallback(() {})
              .request())
          .isGranted;
}
