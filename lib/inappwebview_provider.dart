import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inAppWebViewProvider = ChangeNotifierProvider<InAppWebViewNotifier>(
    (ref) => InAppWebViewNotifier());

class InAppWebViewNotifier extends ChangeNotifier {
  Future<String> getDownloadFileName(String filePath, String fileName) async {
    // 前提として xxxx.apk のファイル名形式
    String tempFileName = fileName;

    bool isExist = true;
    int increment = 1;

    do {
      isExist = await _isExistFile('$filePath/$tempFileName');
      if (isExist) {
        var spName = fileName.split('.');
        tempFileName = '${spName[0]}[$increment].${spName[1]}';
        increment++;
      }
    } while (isExist);

    return tempFileName;
  }

  Future<bool> _isExistFile(String filePath) async {
    return File(filePath).existsSync();
  }
}
