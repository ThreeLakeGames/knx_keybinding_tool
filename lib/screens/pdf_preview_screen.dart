import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '/pdf_widgets/pdf_sub_area.dart';
import '/provider/main_area_data.dart';

class PdfPreviewScreen extends StatefulWidget {
  static const routeName = "/pdf-preview-screen";

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  bool isScrollable = false;

  @override
  Widget build(BuildContext context) {
    final mainAreaData = Provider.of<MainAreaData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Preview"),
      ),
      body: _buildSubAreaDocument(mainAreaData),
    );
  }

  Widget _buildSubAreaDocument(MainAreaData mainAreaData) {
    print("Export started");
    return PdfPreview(
        maxPageWidth: 900,
        build: (format) {
          print("format height: ${format.height}");
          print("format width: ${format.width}");
          final subAreaDocument = _createDocument(mainAreaData, format);

          return subAreaDocument
              .save()
              .whenComplete(() => print("export finished"));
        });
  }

  pw.Document _createDocument(MainAreaData mainAreaData, PdfPageFormat format) {
    final mainAreaDocument = pw.Document();
    final _isLandscape = format.width > format.height;

    mainAreaData.subAreas.forEach(
      (subAreaData) {
        final subAreaPages = PdfSubAreaGenerator(subAreaData)
            .generatePdfSubAreaList(_isLandscape);
        subAreaPages.forEach((subAreaPage) {
          final newPage = _createPage(subAreaPage, format);
          print(newPage.orientation);
          mainAreaDocument.addPage(newPage);
        });
      },
    );

    return mainAreaDocument;
  }

  pw.Page _createPage(PdfSubArea subAreaPage, PdfPageFormat format) {
    return pw.Page(
        margin: pw.EdgeInsets.all(22),
        pageFormat: format,
        build: (ctx) {
          return subAreaPage;
        });
  }

//----- this code was used to allow scrolling with an interactiveViewer -------------

  // void setScrollable(bool scrollable) {
  //   setState(() {
  //     isScrollable = scrollable;
  //   });
  // }

  // bool handleKeyEvent(RawKeyEvent rawKeyEvent) {
  //   if (rawKeyEvent.isShiftPressed) {
  //     if (!isScrollable) {
  //       print("true");
  //       setScrollable(true);
  //     }
  //     return true;
  //   }
  //   if (isScrollable) {
  //     print("false");
  //     setScrollable(false);
  //   }
  //   return false;
  // }
}
