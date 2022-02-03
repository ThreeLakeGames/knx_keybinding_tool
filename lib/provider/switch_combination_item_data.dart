import 'package:flutter/material.dart';
import './switch_item_data.dart';

class SwitchCombinationItemData with ChangeNotifier {
  String id;
  String title;
  List<SwitchItemData> switchList = [];

  SwitchCombinationItemData(this.title, this.switchList, {this.id});

  // this function is used for saving the switches to the database
  Map<String, dynamic> getSwitchCombinationTree() {
    var switchData = List.generate(
        switchList.length, (i) => switchList[i].getSwitchMetaData());
    return {
      "title": this.title,
      "switch_data": switchData,
      "id": id,
    };
  }

  void updateSwitchItems(String currentBrand) {
    switchList.forEach((switchItem) {
      switchItem.updateSwitchType(currentBrand);
    });
  }
}
