import 'dart:io';

import 'package:app_downloader_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloadListProvider = ChangeNotifierProvider<DownloadListNotifier>(
    (ref) => DownloadListNotifier());

class DownloadListNotifier extends ChangeNotifier {
  List<FileSystemEntity>? getDownloadList() {
    return Constants.downloadDirectory?.listSync();
  }

  Future<void> allDelete() async {
    final list = Constants.downloadDirectory!.listSync();
    for (var file in list) {
      file.deleteSync();
    }

    notifyListeners();
  }
}
