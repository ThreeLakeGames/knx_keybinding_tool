import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/sub_area_data.dart';

class MainAreaData with ChangeNotifier {
  String projectName;
  List<SubAreaData> subAreas = [
    // SubAreaData("Erdgeschoss", 0, DateTime.now().toString(), []),
  ];

  int currentSubAreaIndex = 0;
  bool shouldRenderImages = true;
  bool isLoading = false;
  String currentSwitchBrand = "Berker";

  MainAreaData(this.projectName);

  SubAreaData get currentSubArea {
    return subAreas[currentSubAreaIndex];
  }

  void addNewSubArea(SubAreaData newSubArea) {
    // currentSubAreaIndex = subAreas.length;
    newSubArea.index = subAreas.length;
    newSubArea.projectTitle = projectName;
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
    updateIndexOrder();
    if (currentSubAreaIndex == subAreas.length) {
      currentSubAreaIndex -= 1;
    }
    notifyListeners();
  }

  void updateIndexOrder() {
    for (int i = 0; i < subAreas.length; i++) {
      subAreas[i].index = i;
    }
  }

  void storeProject() {
    deleteProjectSaveState().then((_) => storeAllSubAreas());
  }

  void storeAllSubAreas() {
    subAreas.forEach((subArea) async {
      subArea.storeSubArea();
    });
  }

  Future<void> deleteProjectSaveState() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    await http.delete(url).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> loadSubAreas() async {
    isLoading = true;
    print("start loading ${DateTime.now()}");
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http.get(url);
    final loadedSubArea = json.decode(response.body) as Map<String, dynamic>;

    //show loading spinner for 800ms
    Future.delayed(Duration(milliseconds: 800)).then((value) {
      isLoading = false;
      notifyListeners();
    });

    loadedSubArea.keys.forEach((subAreaID) async {
      await loadSubArea(subAreaID);
    });
  }

  Future<void> loadSubArea(subAreaID) async {
    bool isTitleExisting = false;

    // check if sub area already exists in project (currently by title)
    // if sub-area exists --> just load data in sub_area class
    subAreas.forEach(
      (subArea) {
        if (subArea.id == subAreaID) {
          print("project exists");
          isTitleExisting = true;
          return;
        }
      },
    );

    // exit function if subArea already exists
    if (isTitleExisting) {
      notifyListeners();
      return;
    }
    // otherwise create new subArea and add it to subArea List
    final newSubArea = SubAreaData("", subAreas.length, subAreaID, []);
    await newSubArea.loadCurrentSubArea(currentSwitchBrand).then((_) {
      notifyListeners();
      print(newSubArea.index);
    });
    addNewSubArea(newSubArea);
    notifyListeners();
  }

  void updateSwitchBrand(String currentBrand) {
    subAreas.forEach((subArea) {
      subArea.updateSwitchCombinations(currentBrand);
    });
  }

  void setSwitchBrand(String switchBrand) {
    shouldRenderImages = switchBrand != "default";
    currentSwitchBrand = switchBrand;
    updateSwitchBrand(switchBrand);
    notifyListeners();
  }

  void updateSubAreaListView(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final movedSubArea = subAreas.removeAt(oldIndex);
    subAreas.insert(newIndex, movedSubArea);

    // print("oldIndex: $oldIndex  newIndex:  $newIndex");
    //
    // print("-oldIndex: $oldIndex  -newIndex:  $newIndex");
    // subAreas[oldIndex].index = newIndex;
    // subAreas[newIndex].index = oldIndex;
    // subAreas.forEach((element) {
    //   print("unsorted ${element.index}");
    // });

    // subAreas.sort((a, b) => a.index.compareTo(b.index));
    // subAreas.forEach((element) {
    //   print("sorted ${element.index}");
    // });
    updateIndexOrder();
    notifyListeners();
  }
}
