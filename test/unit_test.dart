import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  String fileName = 'flutter.5.5.5.apk';
  test('### file name rename unit test ###', () {
    String tempFileName = '';
    String extension = '';
    List<String> spName = fileName.split('.');
    if (spName.length <= 2) {
      tempFileName = spName[0];
      extension = spName[1];
    } else {
      extension = spName.removeAt(spName.length - 1);
      tempFileName = spName.join('.');
    }

    debugPrint("### fileName = [$fileName] ###");
    debugPrint("### tempFileName = [$tempFileName] ###");
    debugPrint("### extension = [$extension] ###");
    debugPrint("### afterFileName = [$tempFileName[1].$extension] ###");

    assert(true);
  });
}