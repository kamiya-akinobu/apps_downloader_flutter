import 'package:apps_downloader_flutter/download_list_view_model.dart';
import 'package:apps_downloader_flutter/main_screen_view_model.dart';
import 'package:apps_downloader_flutter/provider_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreenPage extends ConsumerWidget {
  const MainScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // このページの状態管理
    final provider = ref.watch(mainScreenProvider);
    // ナビゲーションタブの状態管理
    final stateProvider = ref.watch(navigateStateProvider);
    // Homeタブ内のページ状態管理
    final pageProvider = ref.watch(pageStateProvider);

    final pageController = PageController();
    bool isFinish = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.titles[provider.selectedIndex]),
        actions: stateProvider == NavigateState.info
            ? []
            : pageProvider == PageState.appsDownloader
                ? [_createAppsDownloadActions(ref)]
                : _createDownloadListActions(context, ref),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          // WebViewが表示されていてヒストリバックできる場合は戻る、それ以外はアプリ終了確認
          final webViewController = ref.watch(inAppWebViewStateProvider);
          if (pageProvider == PageState.appsDownloader &&
              webViewController != null &&
              await webViewController.canGoBack()) {
            webViewController.goBack();
          } else {
            if (isFinish) {
              SystemNavigator.pop();
            } else {
              isFinish = true;
              Future.delayed(
                const Duration(seconds: 3),
                () {
                  isFinish = false;
                },
              );
              Fluttertoast.showToast(
                msg: 'もう一度押すと終了します',
                // toastLength: Toast.LENGTH_LONG,
              );
            }
          }
        },
        child: PageView(
          // swipe stop
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: provider.screens,
          onPageChanged: (int index) {
            switch (index) {
              case 1:
                ref
                    .read(navigateStateProvider.notifier)
                    .update((state) => NavigateState.info);
                break;
              case 0:
              default:
                ref
                    .read(navigateStateProvider.notifier)
                    .update((state) => NavigateState.home);
                break;
            }
            provider.onTap(index);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.selectedIndex,
        onTap: (int index) {
          pageController.jumpToPage(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: provider.icons[0],
            label: provider.titles[0],
          ),
          BottomNavigationBarItem(
            icon: provider.icons[1],
            label: provider.titles[1],
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _createAppsDownloadActions(WidgetRef ref) {
    // InAppWebViewのコントローラー取得
    final webViewController = ref.watch(inAppWebViewStateProvider);
    // canGoBack取得
    final canGoBack = ref.watch(canGoBackProvider);
    // canGoForward取得
    final canGoForward = ref.watch(canGoForwardProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: canGoBack
                ? () {
                    webViewController?.goBack();
                  }
                : null,
            disabledColor: Colors.grey,
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: canGoForward
                ? () {
                    webViewController?.goForward();
                  }
                : null,
            disabledColor: Colors.grey,
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
      ],
    );
  }

  List<Widget> _createDownloadListActions(BuildContext context, WidgetRef ref) {
    // ダウンロードリストの状態管理
    final downloadProvider = ref.watch(downloadListProvider);
    final files = downloadProvider.getDownloadList();

    return <Widget>[
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
                                downloadProvider.allDelete();
                                Navigator.pop(context);
                              })
                        ],
                      );
                    });
              },
            )
          : Container(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () async => downloadProvider.refresh,
        ),
      ),
    ];
  }
}
