import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class Constants {
  static final Constants _instance = Constants._internal();

  factory Constants() => _instance;

  Constants._internal() {
    _init();
  }

  static const String appDownloaderUrl = 'https://apps-downloader.dmmga.me/#/';
  static const String caution01 = 'app_downloaderが表示されない場合はネットワークをご確認ください';
  static const String caution02 = '社内であってもJenkinsが表示されない場合はVPN接続してください';
  static const newLine = '\n';



  static Directory? downloadDirectory;
  static String downloadDirectoryPath = '';
  static String appVersion = '';
  static String buildNumber = '';

  Future<void> _init() async {
    downloadDirectory = await getDownloadsDirectory();
    downloadDirectoryPath = downloadDirectory!.path;
    final info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    buildNumber = info.buildNumber;
  }
}
