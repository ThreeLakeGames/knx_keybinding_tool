import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../subArea/sub_area_data.dart';

class MainAreaData with ChangeNotifier {
  String projectID = "default";
  String projectName;
  List<SubAreaData> subAreas = [
    // SubAreaData("Erdgeschoss", 0, DateTime.now().toString(), []),
  ];

  int currentSubAreaIndex = 0;
  bool isStoredInDB = false;
  bool shouldRenderImages = true;
  bool isLoading = false;
  String currentSwitchBrand = "Berker";
  DateTime creationDate;

  MainAreaData(this.projectName, {this.creationDate});

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

  // if project is new created --> add new project to DB
  // if project already exists --> update project in DB
  // return the project-ID
  Future<String> storeProjectData() async {
    Map<String, dynamic> projectData = {
      "projectTitle": projectName,
      "projectID": projectID,
      "projectSwitchBrand": currentSwitchBrand,
      "subAreasData": subAreasSavingData,
      "latestModificationDate": DateTime.now().toIso8601String(),
      "creationDate": creationDate.toIso8601String(),
    };
    if (isStoredInDB) {
      return await patchProjectInDB(projectData);
    } else {
      return await storeNewProjectInDB(projectData);
    }
  }

  List<Map<String, dynamic>> get subAreasSavingData {
    List<Map<String, dynamic>> subAreasSavingData = [];
    subAreas.forEach((subArea) {
      subAreasSavingData.add(subArea.subAreaSaveStateData);
    });
    return subAreasSavingData;
  }

  // update the entire project in DB,  return the project ID
  Future<String> patchProjectInDB(Map<String, dynamic> projectData) async {
    print("patch: $projectID");
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$projectID.json");
    final response = await http
        .patch(url, body: json.encode(projectData))
        .catchError((error) {
      print(error.toString());
      throw error;
    });
    projectID = jsonDecode(response.body)["name"];
    return projectID;
  }

// add the project to DB,  return the project ID
  Future<String> storeNewProjectInDB(Map<String, dynamic> projectData) async {
    print("store: $projectID");

    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http
        .post(url, body: json.encode(projectData))
        .catchError((error) {
      print(error.toString());
      throw error;
    });

    projectID = jsonDecode(response.body)["name"];
    isStoredInDB = true;
    return projectID;
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
    currentSubAreaIndex = 0;
    subAreas.clear();
    projectID = projectId;
    isLoading = true;
    isStoredInDB = true;
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$projectId.json");
    final response = await http.get(url);
    final loadedProjectData =
        json.decode(response.body) as Map<String, dynamic>;

    final loadedSubAreas = loadedProjectData["subAreasData"];
    projectName = loadedProjectData["projectTitle"];
    currentSwitchBrand = loadedProjectData["projectSwitchBrand"];
    creationDate = DateTime.parse(loadedProjectData["creationDate"]);

    //show loading spinner for 800ms
    Future.delayed(Duration(milliseconds: 800)).then((value) {
      isLoading = false;
      notifyListeners();
    });
    if (loadedSubAreas == null) {
      return;
    }

    loadedSubAreas.forEach((loadedSubArea) async {
      await loadSubArea(loadedSubArea);
    });
  }

  Future<void> loadSubArea(Map<String, dynamic> loadedSubArea) async {
    // create new subArea and add it to subArea List
    final newSubArea = SubAreaData("", subAreas.length, "id", []);

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
