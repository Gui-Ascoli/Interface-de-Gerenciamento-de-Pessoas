import 'package:path_provider/path_provider.dart';

class ScreenshotOps{
  
  String _filePath = '';
  final int _cont = 1;


  Future<String> takePath()async{
    final dir = await getExternalStorageDirectory();
    _filePath = '${dir?.path}/ScreenshotFile$_cont.png';
    return _filePath;
  }



  ScreenshotOps();
}

