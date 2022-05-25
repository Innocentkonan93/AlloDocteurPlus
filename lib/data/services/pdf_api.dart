
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';


class PdfApi{
  static Future<File> generateText(String text)async{
    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = Font.ttf(font);
    final pdf = Document();
    pdf.addPage(Page(build: (context){
      return Center(child: Text(text, style: TextStyle(font: ttf, fontSize: 40)), );
    }));
    return saveDocument(name: 'mypdf.pdf', pdf:pdf);
  }

  static Future<File> saveDocument({required String name, required Document pdf,})async{
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$name");


    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file)async{
    final url = file.path;
    await OpenFile.open(url);
  }
}