import 'package:apps_downloader_flutter/download_list_page.dart';
import 'package:apps_downloader_flutter/inappwebview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webViewTabProvider = Provider((ref) => WebViewTabViewModel());

class WebViewTabViewModel extends ChangeNotifier {
  final tabs = <Widget>{
    const Text(
      'Apps Downloader',
      style: TextStyle(fontSize: 18.0),
    ),
    const Text(
      'Download List',
      style: TextStyle(fontSize: 18.0, color: Colors.red),
    ),
  };

  final screens = <Widget>{
    const InAppWebViewPage(),
    const DownloadListPage(),
    // const WebViewPage(),
  };
}
