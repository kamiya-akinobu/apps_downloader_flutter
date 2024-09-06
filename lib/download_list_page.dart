import 'dart:io';

import 'package:app_downloader_flutter/constants.dart';
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
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('All Delete'),
                            actions: [
                              GestureDetector(
                                  child: const Text('No'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(width: 16),
                              GestureDetector(
                                  child: const Text('Yes'),
                                  onTap: () {
                                    notifier.allDelete();
                                    Navigator.pop(context);
                                  })
                            ],
                          );
                        });
                  },
                )
              : Container(),
          files.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => notifier.refresh,
                )
              : Container(),
        ],
      ),
      body: files.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index) {
                final file = File(files[index].path);
                return GestureDetector(
                  onTap: () async {
                    await OpenFile.open(file.path);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              basename(file.path),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              file.lastModifiedSync().toString(),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: _getPopupMenuButton(context, file, notifier),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text('No Downloaded files'),
            ),
    );
  }

  Widget _getPopupMenuButton(
      BuildContext context, File file, DownloadListNotifier notifier) {
    TextEditingController controller = TextEditingController();
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      child: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        return [
          PopupMenuItem<String>(
              child: const ListTile(
                title: Text('Rename'),
              ),
              onTap: () {
                controller.text = basename(file.path);
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Rename'),
                      content: TextField(
                        controller: controller,
                      ),
                      actions: [
                        GestureDetector(
                          child: const Text('Cancel'),
                          onTap: () => Navigator.pop(context),
                        ),
                        GestureDetector(
                          child: const Text('Modify'),
                          onTap: () {
                            notifier.rename(file, controller.text);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
          PopupMenuItem<String>(
            child: const ListTile(
              title: Text('Delete'),
            ),
            onTap: () {
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Delete Confirmation'),
                      content: Text(
                          '${basename(file.path)} ${Constants.newLine} is Delete OK?'),
                      actions: [
                        GestureDetector(
                            child: const Text('No'),
                            onTap: () {
                              Navigator.pop(context);
                            }),
                        const SizedBox(width: 16),
                        GestureDetector(
                            child: const Text('Yes'),
                            onTap: () {
                              notifier.delete(file);
                              Navigator.pop(context);
                            })
                      ],
                    );
                  });
            },
          ),
        ];
      },
    );
  }
}
