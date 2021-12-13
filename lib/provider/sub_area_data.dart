import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:vector_math/vector_math.dart';

import '../provider/demo_data.dart';
import '../provider/switch_combination_item_data.dart';

class SubAreaData with ChangeNotifier {
  String projectTitle;
  String id;
  String title;
  int index;

  DemoData demoData = DemoData();
  List<SwitchCombinationItemData> switchCombinationList = [];

  SubAreaData(this.title, this.index, this.id, this.switchCombinationList,
      {this.projectTitle});
  // SubAreaData.fromWebServer(this.title, this.index, this.id, this.switchCombinationList);

  void addSwitchCombination(SwitchCombinationItemData newSwitchCombination) {
    switchCombinationList.add(newSwitchCombination);
    notifyListeners();
  }

  void clearThenStoreSubArea() {
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
        key: (switchCombItem) {
          return switchCombItem.title;
        },
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
    print(switchCombination.switchList[0].rockerData);
    switchCombinationList.remove(switchCombination);

    notifyListeners();
  }

  Future<void> loadCurrentSubArea(String currentSwitchBrand) async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$title.json");
    final response = await http.get(url);
    final loadedSubArea = json.decode(response.body) as Map<String, dynamic>;
    final switchData = loadedSubArea.values.first;
    switchData.forEach(
      (title, value) {
        List<SwitchItemData> newSwitchItemList = [];
        List<dynamic> switchData = value["switch_data"];
        switchData.forEach(
          (switchItemMap) {
            List<dynamic> rawRockerData = switchItemMap["rockerData"];
            final rockerData = rawRockerData.map((e) => e.toString()).toList();
            final newSwitchItem = SwitchItemData.withValues(
                rockerData,
                Vector2(
                  (switchItemMap["colCount"] as int).toDouble(),
                  (switchItemMap["rowCount"] as int).toDouble(),
                ),
                switchItemMap["switchType"]);
            newSwitchItem.updateSwitchType(currentSwitchBrand);
            newSwitchItemList.add(newSwitchItem);
          },
        );
        SwitchCombinationItemData newSwitchComb =
            SwitchCombinationItemData(value["title"], newSwitchItemList);
        addSwitchCombination(newSwitchComb);
        notifyListeners();
      },
    );
  }

  void updateSwitchCombinations(String currentBrand) {
    switchCombinationList.forEach((switchCombination) {
      switchCombination.updateSwitchItems(currentBrand);
    });
  }

  void setTitle(String newTitle) {
    this.title = newTitle;
    notifyListeners();
  }

  List<List<SwitchCombinationItemData>> getSwitchCombinationPdfExport(
      bool landscape) {
    List<List<SwitchCombinationItemData>> pdfExportList = [];

    int switchesPerPage = 8;
    if (landscape == true) {
      switchesPerPage = 5;
    }
    int pageCount = (switchCombinationList.length / switchesPerPage).ceil();

    for (int i = 0; i < pageCount; i++) {
      var subListStart = i * switchesPerPage;
      var subListEnd = (subListStart + switchesPerPage)
          .clamp(0, switchCombinationList.length);

      pdfExportList
          .add(switchCombinationList.sublist(subListStart, subListEnd));
    }
    return pdfExportList;
  }
}
