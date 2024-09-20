import 'dart:io';

import 'package:apps_downloader_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

final downloadListProvider = ChangeNotifierProvider<DownloadListViewModel>(
    (ref) => DownloadListViewModel());

class DownloadListViewModel extends ChangeNotifier {
  List<FileSystemEntity>? getDownloadList() {
    return Constants.downloadDirectory?.listSync();
  }

  Future<void> refresh() async {
    notifyListeners();
  }

  Future<void>openFile(String filePath) async {
    await OpenFile.open(filePath);
  }

  Future<void> rename(File file, String rename) async {
    debugPrint(file.parent.path);
    await file.rename('${file.parent.path}/$rename');

    await refresh();
  }

  Future<void> allDelete() async {
    final list = Constants.downloadDirectory!.listSync();
    for (var file in list) {
      file.deleteSync();
    }

    await refresh();
  }

  Future<void> delete(File file) async {
    file.deleteSync();
    await refresh();
  }
}
