import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ScreenshotOps {
  String _filePath = '';
  final int _cont = 1;
  late var dir;

  Future<String> takePath() async {
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else if (Platform.isWindows) {
      dir = await getApplicationDocumentsDirectory();
    }

    _filePath = '${dir?.path}/ScreenshotFile$_cont.png';
    return _filePath;
  }

  ScreenshotOps();
}
