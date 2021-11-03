import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';

class MainAreaData with ChangeNotifier {
  List<SubAreaData> subAreas = [
    SubAreaData("Erdgeschoss", 0, DateTime.now().toString(), []),
    SubAreaData("Obergeschoss", 1, DateTime.now().toString(), []),
  ];

  int currentSubAreaIndex = 0;

  MainAreaData();

  SubAreaData get currentSubArea {
    // notifyListeners();
    return subAreas[currentSubAreaIndex];
  }

  void addNewSubArea(SubAreaData newSubArea) {
    currentSubAreaIndex = subAreas.length;
    subAreas.add(newSubArea);
    notifyListeners();
  }

  void setOverviewAreaIndex(int index) {
    currentSubAreaIndex = index;
    notifyListeners();
  }

  void deleteCurrentSubArea() {
    subAreas.removeAt(currentSubAreaIndex);
    updateIndexOrder();
    currentSubAreaIndex -= 1;
    notifyListeners();
  }

  void deleteSubArea(SubAreaData subAreaData) {
    subAreas.remove(subAreaData);
    notifyListeners();
  }

  void updateIndexOrder() {
    for (int i = 0; i < subAreas.length; i++) {
      subAreas[i].index = i;
    }
  }
}
