import 'package:app_downloader_flutter/constants.dart';
import 'package:app_downloader_flutter/download_list_page.dart';
import 'package:app_downloader_flutter/inappwebview_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

// global keep
InAppWebViewController? webViewController;

class InAppWebViewPage extends ConsumerWidget {
  const InAppWebViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(inAppWebViewProvider);
    Permission.notification.request();
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (webViewController != null &&
              await webViewController!.canGoBack()) {
            webViewController!.goBack();
          } else {
            SystemNavigator.pop();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri('https://apps-downloader.dmmga.me/#/'),
                  ),
                  initialSettings:
                      InAppWebViewSettings(useOnDownloadStart: true),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    if (navigationAction.request.url != null &&
                        navigationAction.shouldPerformDownload != null) {
                      return NavigationActionPolicy.DOWNLOAD;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onDownloadStartRequest: (controller, url) async {
                    final path = Constants.downloadDirectoryPath;
                    String fileName = await notifier.getDownloadFileName(
                        path, url.suggestedFilename!);
                    await FlutterDownloader.enqueue(
                      url: url.url.toString(),
                      fileName: fileName,
                      savedDir: path,
                      showNotification: true,
                      openFileFromNotification: true,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          webViewController?.goBack();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          webViewController?.goForward();
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          webViewController?.reload();
                        },
                        icon: const Icon(
                          Icons.replay,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DownloadList(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
