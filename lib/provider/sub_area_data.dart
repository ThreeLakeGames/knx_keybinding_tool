import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:vector_math/vector_math.dart';

import '../provider/demo_data.dart';
import '../provider/switch_combination_item_data.dart';

class SubAreaData with ChangeNotifier {
  String id;
  String title;
  int index;

  DemoData demoData = DemoData();
  List<SwitchCombinationItemData> switchCombinationList = [];

  SubAreaData(this.title, this.index, this.id, this.switchCombinationList);
  // SubAreaData.fromWebServer(this.title, this.index, this.id, this.switchCombinationList);

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

  void updateSubArea() {
    deleteSubArea().then((value) => storeSubArea());
  }

  Future<void> deleteSubArea() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$title.json");
    await http.delete(url).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> storeSubArea() async {
    //create Map of all switchcombinations
    //key = name
    var switchCombinationMap = Map.fromIterable(switchCombinationList,
        key: (switchCombItem) => switchCombItem.title,
        value: (switchCombItem) => switchCombItem.getSwitchCombinationTree());
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$title.json");

    await http
        .post(url, body: json.encode(switchCombinationMap))
        .catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  void deleteSwitchCombination(SwitchCombinationItemData switchCombination) {
    switchCombinationList.remove(switchCombination);

    notifyListeners();
  }

  Future<void> loadCurrentSubArea() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$title.json");
    final response = await http.get(url);
    final loadedSubArea = json.decode(response.body) as Map<String, dynamic>;
    final switchData = loadedSubArea.values.first;
    // print(loadedSubArea);
    switchData.forEach(
      (title, value) {
        List<SwitchItemData> newSwitchItemList = [];
        // print("key: $title \nvalue: $value");
        List<dynamic> switchData = value["switch_data"];
        switchData.forEach(
          (switchItemMap) {
            List<dynamic> rawRockerData = switchItemMap["rockerData"];
            final rockerData = rawRockerData.map((e) => e.toString()).toList();
            final newSwitchItem = SwitchItemData.withValues(
              rockerData,
              Vector2(
                switchItemMap["colCount"],
                switchItemMap["rowCount"],
              ),
            );
            newSwitchItemList.add(newSwitchItem);
            print("element:  $switchItemMap");
          },
        );
        SwitchCombinationItemData newSwitchComb =
            SwitchCombinationItemData(title, newSwitchItemList);
        addSwitchCombination(newSwitchComb);
        notifyListeners();
      },
    );
  }
}
