import 'package:apps_downloader_flutter/provider_config.dart';
import 'package:apps_downloader_flutter/webview_tab_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebViewTabPage extends StatefulHookConsumerWidget {
  const WebViewTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebViewTabPageState();
}

class _WebViewTabPageState extends ConsumerState<WebViewTabPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<WebViewTabPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = ref.watch(webViewTabProvider);
    final tabController =
        TabController(length: provider.screens.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
            switch (tabController.index) {
              case 0:
                ref.read(pageStateProvider.notifier).update((state) => PageState.appsDownloader);
                break;
              case 1:
                ref.read(pageStateProvider.notifier).update((state) => PageState.downloadList);
                break;
            }
      }
    });

    return SafeArea(
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
            controller: tabController,
            tabs: provider.tabs.toList(),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: provider.screens.toList(),
            ),
          ),
        ],
      ),
    );
  }
}
