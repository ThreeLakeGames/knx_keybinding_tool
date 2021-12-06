import 'package:knx_keybinding_tool/pdf_widgets/pdf_switch_combination.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSubArea extends pw.StatelessWidget {
  final SubAreaData subAreaData;
  final List<SwitchCombinationItemData> switchListData;

  PdfSubArea(this.subAreaData, this.switchListData);

  @override
  pw.Widget build(pw.Context context) {
    // return pw.Center(child: pw.Text("subArea"));
    return pw.Column(children: [
      pw.Container(
        width: double.infinity,
        height: 30,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 2),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Text(subAreaData.projectTitle),
            pw.Text(subAreaData.title),
            pw.Text(DateFormat.yMMMd().format(DateTime.now())),
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(20.0),
        child: pw.Wrap(
          spacing: 20,
          runSpacing: 10,
          children: buildSwitchCombinationItems(switchListData),
        ),
      ),
    ]);
  }

  List<pw.Widget> buildSwitchCombinationItems(
      List<SwitchCombinationItemData> switchCombinationDataList) {
    List<pw.Widget> switchCombinationList = [];

    switchCombinationDataList.forEach(
      (switchCombinationData) {
        switchCombinationList.add(PdfSwitchCombination(switchCombinationData));
      },
    );
    return switchCombinationList;
  }
}

class PdfSubAreaGenerator {
  final SubAreaData subAreaData;

  PdfSubAreaGenerator(this.subAreaData);

  List<PdfSubArea> generatePdfSubAreaList(bool isLandscape) {
    final switchCombinationLists =
        subAreaData.getSwitchCombinationPdfExport(isLandscape);

    List<PdfSubArea> pdfSubAreaList = [];
    // PdfSubArea newPdfSubArea = PdfSubArea(subAreaData, []);
    switchCombinationLists.forEach((switchCombinationList) {
      pdfSubAreaList.add(PdfSubArea(subAreaData, switchCombinationList));
    });
    // pdfSubAreaList.add(
    //     PdfSubArea(subAreaData, subAreaData.switchCombinationList.sublist(0)));

    return pdfSubAreaList;
  }
}
