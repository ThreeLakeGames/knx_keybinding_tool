import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';

class SwitchCombinationItemData with ChangeNotifier {
  String id;
  String title;
  List<SwitchItemData> switchList = [];

  SwitchCombinationItemData(this.title, this.switchList);

  // this function is used for saving the switches to webserver
  Map<String, dynamic> getSwitchCombinationTree() {
    var switchData = List.generate(
        switchList.length, (i) => switchList[i].getSwitchMetaData());
    return {
      "title": this.title,
      "switch_data": switchData,
    };
  }

  void updateSwitchItems(String currentBrand) {
    switchList.forEach((switchItem) {
      switchItem.updateSwitchType(currentBrand);
    });
  }
}
