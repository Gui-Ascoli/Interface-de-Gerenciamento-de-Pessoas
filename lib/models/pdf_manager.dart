import 'dart:io';
import 'dart:typed_data';
import 'package:banco/models/screenshot.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfManager{

  final ScreenshotOps _screenshot = ScreenshotOps();
  final pdf = pw.Document();
  String _filePath = '';

  Future<void> textPdf() async {
    pdf.addPage(
      pw.Page(
        build: (context) {
          return _pdfContent();
        },
      ),
    );

    _savePdf(pdf);
    await Printing.layoutPdf(
      onLayout: (_) async=> pdf.save(),
      format: PdfPageFormat.a4,
    );
    print('PDF enviado a impressora');
  }

  pw.Widget _pdfContent (){
    return pw.Container(
      height: 500,
      width: 500,

      child:pw.Column(
        children: [
          pw.Center(
            child: pw.Text('Hello World', style: const pw.TextStyle(fontSize: 80)),
          ),
          pw.Expanded(
            child: pw.Text(
              'anderson precisastes',
              style:const pw.TextStyle(
                fontSize: 100,
                )
              )
            )
        ],
      )  
    );
  }

  Future<void> printToPdf()async{
    Uint8List fileImage = File(await _screenshot.takePath()).readAsBytesSync();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            width: 500,
            height: 500.0,
            child: pw.Image(pw.MemoryImage(fileImage))
         );
        },
      ),
    );
    _savePdf(pdf);
  }

  Future<void> _savePdf(var pdfe)async{
    final file = File(await _takePath());
    await file.writeAsBytes(pdfe);
    print('pdf com imagem salvo em $file');
  }

  Future<String> _takePath()async{
    final dir = await getExternalStorageDirectory();
    _filePath = '${dir?.path}/example3.png';
    return _filePath;
  }

  PdfManager();
  
}