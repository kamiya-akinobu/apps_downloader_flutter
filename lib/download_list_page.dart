import 'dart:io';

import 'package:apps_downloader_flutter/constants.dart';
import 'package:apps_downloader_flutter/download_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadListPage extends ConsumerWidget {
  const DownloadListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(downloadListProvider);
    final files = provider.getDownloadList();

    Permission.requestInstallPackages.request();

    return SafeArea(
      child: files!.isNotEmpty
          ? ListView.separated(
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index) {
                final file = File(files[index].path);
                return ListTile(
                  title: Text(basename(file.path)),
                  subtitle: Text(file.lastModifiedSync().toString()),
                  trailing: _getPopupMenuButton(context, file, provider),
                  onTap: () async {
                    await provider.openFile(file.path);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0.5),
            )
          : const Center(
              child: Text('No Downloaded files'),
            ),
    );
  }

  Widget _getPopupMenuButton(
    BuildContext context,
    File file,
    DownloadListViewModel provider,
  ) {
    TextEditingController controller = TextEditingController();
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      child: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        return [
          PopupMenuItem<String>(
            child: const ListTile(
              title: Text('Install'),
              leading: Icon(Icons.install_mobile),
            ),
            onTap: () async {
              await provider.openFile(file.path);
            },
          ),
          PopupMenuItem<String>(
            child: const ListTile(
              title: Text('Rename'),
              leading: Icon(Icons.drive_file_rename_outline_rounded),
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
                          provider.rename(file, controller.text);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
          PopupMenuItem<String>(
            child: const ListTile(
              title: Text('Delete'),
              leading: Icon(Icons.delete),
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
                        },
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        child: const Text('Yes'),
                        onTap: () {
                          provider.delete(file);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ];
      },
    );
  }
}
