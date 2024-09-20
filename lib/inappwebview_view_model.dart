import 'dart:io';

import 'package:apps_downloader_flutter/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inAppWebViewProvider = ChangeNotifierProvider<InAppWebViewViewModel>(
    (ref) => InAppWebViewViewModel());

class InAppWebViewViewModel extends ChangeNotifier {
  // Download処理
  Future<void> download(DownloadStartRequest url) async {
    final path = Constants.downloadDirectoryPath;
    String fileName = await _getDownloadFileName(path, url.suggestedFilename!);
    await FlutterDownloader.enqueue(
      url: url.url.toString(),
      fileName: fileName,
      savedDir: path,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  // ダウンロードファイル名を取得
  Future<String> _getDownloadFileName(String filePath, String fileName) async {
    // 同名ファイルがある場合はindexを付加 (ex: exist [build.apk] => build[1].apk)
    String tempFileName = '';
    String extension = '';
    List<String> spName = fileName.split('.');
    if (spName.length <= 2) {
      tempFileName = spName[0];
      extension = spName[1];
    } else {
      extension = spName.removeAt(spName.length - 1);
      tempFileName = spName.join('.');
    }

    bool isExist = true;
    int increment = 0;

    do {
      isExist = await _isExistFile('$filePath/$tempFileName');
      if (isExist) {
        increment++;
        tempFileName = '$tempFileName[$increment].$extension';
      }
    } while (isExist);

    return tempFileName;
  }

  Future<bool> _isExistFile(String filePath) async {
    return File(filePath).existsSync();
  }
}
