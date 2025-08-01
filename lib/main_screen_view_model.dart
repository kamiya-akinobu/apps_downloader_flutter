import 'package:apps_downloader_flutter/information_page.dart';
import 'package:apps_downloader_flutter/webview_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainScreenProvider =
    ChangeNotifierProvider<MainScreenViewModel>((ref) => MainScreenViewModel());

class MainScreenViewModel extends ChangeNotifier {

  final icons = <Icon>[
    const Icon(Icons.home),
    const Icon(Icons.info),
  ];

  final titles = <String>[
    'Home',
    'Info',
  ];

  final screens = <Widget>[
    // const InAppWebViewPage(),
    const WebViewTabPage(),
    // const DownloadListPage(),
    const InformationPage(),
  ];

  int selectedIndex = 0;

  void refresh() {
    notifyListeners();
  }

  void onTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isShowHome() {
    return selectedIndex == 0;
  }
}
