import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/sub_area_data.dart';

class MainAreaData with ChangeNotifier {
  String projectName;
  List<SubAreaData> subAreas = [
    SubAreaData("Erdgeschoss", 0, DateTime.now().toString(), []),
    SubAreaData("Obergeschoss", 1, DateTime.now().toString(), []),
  ];

  int currentSubAreaIndex = 0;

  MainAreaData(this.projectName);

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
    if (currentSubAreaIndex > 0) {
      currentSubAreaIndex -= 1;
    }
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

  void storeAllSubAreas() {
    subAreas.forEach((subArea) async {
      subArea.updateSubArea();
    });
  }

  Future<void> loadSubAreas() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http.get(url);
    final loadedSubArea = json.decode(response.body) as Map<String, dynamic>;
    print(loadedSubArea.keys.toList().length);
    loadedSubArea.keys.forEach((subAreaTitle) {
      print("load key: $subAreaTitle");
      loadSubArea(subAreaTitle);
    });
  }

  void loadSubArea(String title) {
    bool isTitleExisting = false;

    // check if sub area already exists in project (currently by title)
    // if sub-area exists --> just load data in sub_area class
    subAreas.forEach(
      (subArea) {
        if (subArea.title == title) {
          subArea.loadCurrentSubArea();
          print("loaded title equals existing title");
          isTitleExisting = true;
        }
      },
    );
    // exit function if subArea already exists
    if (isTitleExisting) {
      notifyListeners();
      return;
    }
    // otherwise create new subArea and add it to subArea List
    final newSubArea =
        SubAreaData(title, subAreas.length, DateTime.now().toString(), []);
    newSubArea.loadCurrentSubArea();
    addNewSubArea(newSubArea);
    notifyListeners();
  }
}
