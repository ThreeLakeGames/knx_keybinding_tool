import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:vector_math/vector_math.dart';

import '../provider/switch_combination_item_data.dart';

class SubAreaData with ChangeNotifier {
  String projectTitle;
  String id;
  String title;
  int index;

  bool isCurrentSubArea = false;

  List<SwitchCombinationItemData> switchCombinationList = [];

  SubAreaData(this.title, this.index, this.id, this.switchCombinationList,
      {this.projectTitle});
  // SubAreaData.fromWebServer(this.title, this.index, this.id, this.switchCombinationList);

  void addSwitchCombination(SwitchCombinationItemData newSwitchCombination) {
    switchCombinationList.add(newSwitchCombination);
    notifyListeners();
  }

//
  Map<String, dynamic> get subAreaSaveStateData {
    var switchCombinationMap = Map.fromIterable(switchCombinationList,
        key: (switchCombItem) {
          return switchCombItem.id;
        },
        value: (switchCombItem) => switchCombItem.getSwitchCombinationTree());

    Map<String, dynamic> subAreaMap = {
      "areaTitle": title,
      "switchData": switchCombinationMap,
    };
    return subAreaMap;
  }

  void deleteSwitchCombination(SwitchCombinationItemData switchCombination) {
    switchCombinationList.remove(switchCombination);

    notifyListeners();
  }

  Future<void> loadCurrentSubArea({
    Map<String, dynamic> loadedSubarea,
    String currentSwitchBrand,
  }) async {
    final switchData = loadedSubarea["switchData"];
    title = loadedSubarea["areaTitle"];
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
        SwitchCombinationItemData newSwitchComb = SwitchCombinationItemData(
            value["title"], newSwitchItemList,
            id: value["id"]);
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
