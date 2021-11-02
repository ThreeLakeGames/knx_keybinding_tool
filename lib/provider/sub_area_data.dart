import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/demo_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';

class SubAreaData with ChangeNotifier {
  String id;
  String title;
  int index;

  List<SwitchCombinationItemData> switchCombinationList =
      DemoData.testSwitchArea;

  SubAreaData(this.title, this.index, this.id);

  void addSwitchCombination(SwitchCombinationItemData newSwitchCombination) {
    switchCombinationList.add(newSwitchCombination);
    notifyListeners();
  }

  void deleteSwitchCombination(SwitchCombinationItemData switchCombination) {
    switchCombinationList.remove(switchCombination);

    notifyListeners();
  }
}
