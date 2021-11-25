import 'package:knx_keybinding_tool/pdf_widgets/pdf_switch_combination.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';

import 'package:pdf/widgets.dart' as pw;

class PdfSubArea extends pw.StatelessWidget {
  final SubAreaData subAreaData;

  PdfSubArea(this.subAreaData);

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
        child: pw.Center(
          child: pw.Text(subAreaData.title),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(20.0),
        child: pw.Wrap(
          spacing: 20,
          runSpacing: 10,
          children:
              _buildSwitchCombinationItems(subAreaData.switchCombinationList),
        ),
      ),
    ]);
  }

  List<pw.Widget> _buildSwitchCombinationItems(
      List<SwitchCombinationItemData> switchCombinationDataList) {
    List<pw.Widget> switchCombinationList = [];

    switchCombinationDataList.forEach(
      (switchCombinationData) {
        // print("title:  ${switchCombinationData.title}");
        switchCombinationList.add(PdfSwitchCombination(switchCombinationData));
      },
    );
    return switchCombinationList;
  }
}
