import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            text,
            style: const pw.TextStyle(fontSize: 48),
          ),
        ),
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name'); // Added closing parenthesis

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> openFile(File file) async {
    // Removed async keyword
    final url = file.path;
    OpenFile.open(url);
  }
}
