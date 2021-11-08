import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';

class SwitchCombinationItemData with ChangeNotifier {
  String id;
  String title;
  List<SwitchItemData> switchList = [];

  SwitchCombinationItemData(this.title, this.switchList);

  Map<String, dynamic> getSwitchCombinationTree() {
    var switchData = List.generate(
        switchList.length, (i) => switchList[i].getSwitchMetaData());
    print(switchData);
    return {
      "title": this.title,
      "switch_data": switchData,
    };
  }
}
