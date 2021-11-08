import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/demo_data.dart';
import '../provider/switch_combination_item_data.dart';

class SubAreaData with ChangeNotifier {
  String id;
  String title;
  int index;

  DemoData demoData = DemoData();
  List<SwitchCombinationItemData> switchCombinationList = [];

  SubAreaData(this.title, this.index, this.id, this.switchCombinationList);

  void addSwitchCombination(SwitchCombinationItemData newSwitchCombination) {
    // final url = Uri.parse(
    //     "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/sub_area$title.json");
    // http
    //     .post(url,
    //         body: json.encode(newSwitchCombination.getSwitchCombinationTree()))
    //     .catchError((error) {
    //   print(error.toString());
    // });
    switchCombinationList.add(newSwitchCombination);
    notifyListeners();
  }

  void storeSubArea() {
    var switchCombinationMap = Map.fromIterable(switchCombinationList,
        key: (switchCombItem) => switchCombItem.title,
        value: (switchCombItem) => switchCombItem.getSwitchCombinationTree());
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/sub_area$title.json");
    http.post(url, body: json.encode(switchCombinationMap)).catchError((error) {
      print(error.toString());
    });
  }

  void deleteSwitchCombination(SwitchCombinationItemData switchCombination) {
    switchCombinationList.remove(switchCombination);

    notifyListeners();
  }
}
