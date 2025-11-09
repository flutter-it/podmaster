import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart';

import '../app/app_config.dart';

class Platforms {
  static bool get isWeb => kIsWeb;
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  static bool get isFuchsia => !kIsWeb && Platform.isFuchsia;
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isDesktop => !kIsWeb && (isLinux || isWindows || isMacOS);
  static bool get isMobile => !kIsWeb && (isIOS || isAndroid || isFuchsia);
}

extension PlatformX on Platform {
  static Future<String?> getDownloadsDefaultDir() async {
    String? path;
    if (Platforms.isLinux) {
      path = getUserDirectory('DOWNLOAD')?.path;
    } else if (Platforms.isMacOS || Platforms.isIOS || Platforms.isWindows) {
      path = (await getDownloadsDirectory())?.path;
    } else if (Platforms.isAndroid) {
      final androidDir = Directory('/storage/emulated/0/Download');
      if (androidDir.existsSync()) {
        path = androidDir.path;
      }
    }
    if (path != null) {
      return p.join(path, AppConfig.appName);
    }
    return null;
  }
}
