import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Constants {
  static final Constants _instance = Constants._internal();

  factory Constants() => _instance;

  Constants._internal() {
    _init();
  }

  static Directory? downloadDirectory;
  static String downloadDirectoryPath = '';

  Future<void> _init() async {
    downloadDirectory = await getDownloadsDirectory();
    downloadDirectoryPath = downloadDirectory!.path;
  }
}
