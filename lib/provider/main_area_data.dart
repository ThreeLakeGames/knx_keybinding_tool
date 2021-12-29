import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/sub_area_data.dart';

class MainAreaData with ChangeNotifier {
  String projectID = "default";
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
    subAreas[index].isCurrentSubArea = true;
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
      if (subAreas[i].isCurrentSubArea) currentSubAreaIndex = i;
      subAreas[i].index = i;
    }
  }

  void storeProject() {
    deleteProjectSaveState().then((_) => storeAllSubAreas());
  }

  Future<void> storeProjectData() async {
    await deleteProjectSaveState().then((_) => storeProjectInDB());
  }

  List<Map<String, dynamic>> get subAreasSavingData {
    List<Map<String, dynamic>> subAreasSavingData = [];
    subAreas.forEach((subArea) {
      // print(subArea.subAreaSaveStateData);
      subAreasSavingData.add(subArea.subAreaSaveStateData);
    });
    return subAreasSavingData;
  }

  void storeProjectInDB() async {
    print("store: $projectID");
    Map<String, dynamic> projectData = {
      "projectTitle": projectName,
      "projectID": projectID,
      "subAreasData": subAreasSavingData,
    };

    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http
        .post(url, body: json.encode(projectData))
        .catchError((error) {
      print(error.toString());
      throw error;
    });

    projectID = jsonDecode(response.body)["name"];
  }

  void storeAllSubAreas() {
    subAreas.forEach((subArea) async {
      subArea.storeSubArea();
    });
  }

  Future<void> deleteProjectSaveState() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$projectID.json");
    await http.delete(url).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> loadProject(String projectId) async {
    print("loading Project: $projectId");
    projectID = projectId;
    isLoading = true;
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$projectId.json");
    final response = await http.get(url);
    final loadedProjectData =
        json.decode(response.body) as Map<String, dynamic>;
    final loadedSubAreas = loadedProjectData["subAreasData"];
    // print("loaded ProjectData: $loadedSubAreas");

    //show loading spinner for 800ms
    Future.delayed(Duration(milliseconds: 800)).then((value) {
      isLoading = false;
      notifyListeners();
    });

    loadedSubAreas.forEach((loadedSubArea) async {
      await loadSubArea("", loadedSubArea);
    });
  }

  Future<void> loadSubArea(
      subAreaID, Map<String, dynamic> loadedSubArea) async {
    bool isTitleExisting = false;

    // check if sub area already exists in project (using the ID)
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
    await newSubArea
        .loadCurrentSubArea(
            loadedSubarea: loadedSubArea,
            currentSwitchBrand: currentSwitchBrand)
        .then((_) {
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

    //keep the right "currentSubAreaIndex"
    resetSubAreasIsCurrentState();
    currentSubArea.isCurrentSubArea = true;
    final movedSubArea = subAreas.removeAt(oldIndex);
    subAreas.insert(newIndex, movedSubArea);

    updateIndexOrder();
    notifyListeners();
  }

  void resetSubAreasIsCurrentState() {
    subAreas.forEach((subArea) {
      subArea.isCurrentSubArea = false;
    });
  }
}
