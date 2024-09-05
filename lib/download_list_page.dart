import 'dart:io';

import 'package:app_downloader_flutter/download_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadList extends ConsumerWidget {
  const DownloadList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(downloadListProvider);
    final files = notifier.getDownloadList();

    Permission.requestInstallPackages.request();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ダウンロード一覧'),
        actions: [
          files!.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('すべて削除する'),
                            actions: [
                              GestureDetector(
                                  child: const Text('いいえ'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(width: 16),
                              GestureDetector(
                                  child: const Text('はい'),
                                  onTap: () {
                                    notifier.allDelete();
                                    Navigator.pop(context);
                                  })
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete),
                )
              : Container()
        ],
      ),
      body: files.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: files?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final file = File(files![index].path);
                return Row(
                  children: [
                    Expanded(child: Text(basename(file.path))),
                    SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () async {
                          await OpenFile.open(file.path);
                          file.open();
                        },
                        child: const Text('Install'),
                      ),
                    )
                  ],
                );
              },
            )
          : const Center(
              child: Text('ダウンロードしたファイルはありません'),
            ),
    );
  }
}
