import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

@Deprecated('exchange in_app_webview')
class WebViewPage extends ConsumerWidget {
  const WebViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = WebViewController()
      ..loadRequest(Uri.parse('https://apps-downloader.dmmga.me/#/'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate());

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            SystemNavigator.pop();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: WebViewWidget(
                  controller: controller,
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
                          controller.goBack();
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
                          controller.goForward();
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
                          controller.reload();
                        },
                        icon: const Icon(
                          Icons.replay,
                        ),
                      ),
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
