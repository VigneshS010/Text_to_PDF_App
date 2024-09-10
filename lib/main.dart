import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:test_pdf/pdf_api.dart';

class NameToPdfApp extends StatefulWidget {
  const NameToPdfApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NameToPdfAppState createState() => _NameToPdfAppState();
}

class _NameToPdfAppState extends State<NameToPdfApp> {
  final TextEditingController _textController = TextEditingController();
  bool _pdfGenerated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name to PDF Converter"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_textController.text.isNotEmpty) {
                final pdfFile = await generatePdf(_textController.text);
                PdfApi.openFile(pdfFile);
                setState(() {
                  // Update the state
                  _pdfGenerated = true;
                });
              }
            },
            icon: const Icon(Icons.file_copy_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_textController.text.isNotEmpty) {
                  final pdfFile = await generatePdf(_textController.text);
                  PdfApi.openFile(pdfFile);
                  setState(() {
                    _pdfGenerated = true;
                  });
                }
              },
              child: const Text('Generate PDF'),
            ),
            _pdfGenerated ? const Text('PDF generated successfully!') : Container(),
          ],
        ),
      ),
    );
  }

  Future<File> generatePdf(String text) async {
    final pdf = pw.Document();

    final openSansFont =
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                font: pw.Font.ttf(openSansFont),
                fontSize: 24,
              ),
            ),
          );
        },
      ),
    );

    final uint8List = await pdf.save();

    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/pdf_file.pdf');
    await file.writeAsBytes(uint8List);

    return file; // Return the File object
  }
}

void main() {
  runApp(const MaterialApp(home: NameToPdfApp()));
}
