import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/pdf_widgets/pdf_sub_area.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreviewScreen extends StatelessWidget {
  static const routeName = "/pdf-preview-screen";
  @override
  Widget build(BuildContext context) {
    final mainAreaData = Provider.of<MainAreaData>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("PDF Preview"),
        ),
        body: _buildSubAreaDocument(mainAreaData));
  }

  Widget _buildSubAreaDocument(MainAreaData mainAreaData) {
    return PdfPreview(build: (format) {
      final subAreaDocument = _createDocument(mainAreaData, format);

      return subAreaDocument.save();
    });
  }

  pw.Document _createDocument(MainAreaData mainAreaData, PdfPageFormat format) {
    final mainAreaDocument = pw.Document();
    mainAreaData.subAreas.forEach(
      (subAreaData) {
        mainAreaDocument.addPage(pw.Page(
            pageFormat: format,
            build: (ctx) {
              return PdfSubArea(subAreaData);
            }));
      },
    );
    return mainAreaDocument;
  }
}
