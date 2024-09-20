import 'package:apps_downloader_flutter/constants.dart';
import 'package:apps_downloader_flutter/inappwebview_view_model.dart';
import 'package:apps_downloader_flutter/provider_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class InAppWebViewPage extends StatefulHookConsumerWidget {
  const InAppWebViewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InAppWebViewPageState();
}

/// AutomaticKeepAliveClientMixinをwithするためにConsumerStateを継承
class _InAppWebViewPageState extends ConsumerState<InAppWebViewPage>
    with AutomaticKeepAliveClientMixin {

  // タブ切り替えの毎に更新させない
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Permission.notification.request();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _createInAppWebView(context),
          ),
        ],
      ),
    );
  }

  Widget _createInAppWebView(BuildContext context) {
    final provider = ref.watch(inAppWebViewProvider);

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(Constants.appsDownloaderUrl),
      ),
      initialSettings: InAppWebViewSettings(useOnDownloadStart: true),
      onWebViewCreated: (controller) {
        ref.read(inAppWebViewStateProvider.notifier).state = controller;
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        if (navigationAction.request.url != null &&
            navigationAction.shouldPerformDownload != null) {
          return NavigationActionPolicy.DOWNLOAD;
        }
        return NavigationActionPolicy.ALLOW;
      },
      onDownloadStartRequest: (controller, url) async {
        await provider.download(url);
      },
      onLoadStop: (controller, url) async {
        // 状態管理
        controller.canGoBack().then(
            (onValue) => ref.read(canGoBackProvider.notifier).state = onValue);
        controller.canGoForward().then((onValue) =>
            ref.read(canGoForwardProvider.notifier).state = onValue);
      },
      onReceivedHttpError: (controller, request, errorResponse) async {
        if (errorResponse.statusCode == 403) {
          Fluttertoast.showToast(
            msg: 'VPNの接続を確認してみてください',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
    );
  }
}
