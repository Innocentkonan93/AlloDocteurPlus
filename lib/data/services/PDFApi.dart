import 'dart:io';
import 'pdf_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PDFApi {
  static Future<File> loadNetwork(String endPoint) async {
    Uri url = Uri.parse(endPoint);
    final response = await http.get(url);
    final bytes = response.bodyBytes;
    print(bytes);
    return _storeFile(endPoint, bytes);
  }

  static Future pickeFile()async{
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  if(result == null)return;
  print(result.paths.first);
    return File(result.paths.first!);
  }



  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    print(file.path);
    PdfApi.openFile(file);
    return file;
  }
}
