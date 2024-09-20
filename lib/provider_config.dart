import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 状態管理
// BottomNavigateBarの状態管理
enum NavigateState {
  home,
  info,
}

final StateProvider<NavigateState> navigateStateProvider =
    StateProvider<NavigateState>((ref) => NavigateState.home);

// PageViewの状態管理
enum PageState {
  appsDownloader,
  downloadList,
}

final StateProvider<PageState?> pageStateProvider =
    StateProvider<PageState?>((ref) => PageState.appsDownloader);

// InAppWebViewControllerの状態管理
final StateProvider<InAppWebViewController?> inAppWebViewStateProvider =
    StateProvider<InAppWebViewController?>((ref) => null);
// ブラウザBack可否の状態管理
final StateProvider<bool> canGoBackProvider =
    StateProvider<bool>((ref) => false);
// ブラウザForward可否の状態管理
final StateProvider<bool> canGoForwardProvider =
    StateProvider<bool>((ref) => false);
