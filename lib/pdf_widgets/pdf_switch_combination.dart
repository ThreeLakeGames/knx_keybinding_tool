import 'package:knx_keybinding_tool/pdf_widgets/pdf_switch_item.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSwitchCombination extends pw.StatelessWidget {
  final SwitchCombinationItemData switchCombinationItemData;

  PdfSwitchCombination(this.switchCombinationItemData);

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: 225 / 2,
      child: pw.Column(
        children: [
          pw.Text(switchCombinationItemData.title,
              softWrap: true, style: pw.TextStyle(color: PdfColors.blue)),
          pw.SizedBox(height: 4),
          pw.Column(
            children: _buildSwitchItems(switchCombinationItemData.switchList),
          )
        ],
      ),
    );
  }

  List<pw.Widget> _buildSwitchItems(List<SwitchItemData> switchList) {
    List<pw.Widget> switchItemList = [];
    switchList.forEach(
      (switchItemData) {
        switchItemList.add(
          pw.Column(
            children: [
              PdfSwitchItem(switchItemData),
              pw.SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
    return switchItemList;
  }
}
