import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSwitchItem extends pw.StatelessWidget {
  static const WIDTH = 200.0;
  static const HEIGHT = 200.0;
  final SwitchItemData switchItemData;

  PdfSwitchItem(this.switchItemData);

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      // padding: pw.EdgeInsets.all(1),
      width: WIDTH / 2 + 2,
      height: HEIGHT / 2 + 2,
      decoration: pw.BoxDecoration(
        color: PdfColor(
          0.75,
          0.75,
          0.75,
        ),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
        boxShadow: [
          pw.BoxShadow(
              color: PdfColors.grey50,
              offset: PdfPoint(3.0, 3.0), //(x,y)
              blurRadius: 6.0,
              spreadRadius: 20.0)
        ],
        border: pw.Border.all(
          width: 2,
          color: PdfColors.black,
        ),
      ),
      child: pw.Padding(
          padding: pw.EdgeInsets.all(1.0),
          child: _buildSpecificSwitch(switchItemData)),
    );
  }

  pw.Widget _buildSpecificSwitch(SwitchItemData switchData) {
    return pw.Wrap(
      crossAxisAlignment: pw.WrapCrossAlignment.start,
      children: List<PdfRockerTile>.generate(
        switchData.totalRockerSize,
        (index) => PdfRockerTile(
            WIDTH / 2 / switchData.rockerDimension.x,
            HEIGHT / 2 / switchData.rockerDimension.y,
            switchData.rockerData[index]),
      ),
    );
  }
}

class PdfRockerTile extends pw.StatelessWidget {
  final width;
  final height;
  final String text;

  PdfRockerTile(this.width, this.height, this.text);
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: width,
      height: height,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
          color: PdfColors.black,
        ),
      ),
      child: pw.Center(
        child: pw.Text(text),
      ),
    );
  }
}
