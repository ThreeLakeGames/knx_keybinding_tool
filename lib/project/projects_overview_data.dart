import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/project_basic_data.dart';
import '../provider/main_area_data.dart';

class ProjectsOverviewData extends ChangeNotifier {
  List<ProjectBasicData> projects = [];

  Future<void> loadProjects() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http.get(url);
    final loadedProjects = json.decode(response.body) as Map<String, dynamic>;

    projects.clear();
    loadedProjects.forEach((key, loadedData) {
      final newProjectBasicData = ProjectBasicData(
        projectID: key,
        projectTitle: loadedData["projectTitle"],
        latestModificationDate:
            DateTime.parse(loadedData["latestModificationDate"]),
        creationDate: DateTime.parse(loadedData["creationDate"]),
        projectSwitchBrand: loadedData["projectSwitchBrand"],
      );
      projects.add(newProjectBasicData);
    });
  }

  Future<void> addNewProject(MainAreaData newProject) async {
    var newProjectsBasicData = ProjectBasicData(
      projectID: newProject.projectID,
      projectTitle: newProject.projectName,
      projectSwitchBrand: newProject.currentSwitchBrand,
      creationDate: newProject.creationDate,
      latestModificationDate: DateTime.now(),
    );
    projects.add(newProjectsBasicData);
    await newProject
        .storeProjectData()
        .then((projectID) => newProjectsBasicData.projectID = projectID);
  }

  Future<void> deleteProject(String projectID) async {
    projects.removeWhere(
        (projectBasicData) => projectBasicData.projectID == projectID);
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/$projectID.json");
    await http.delete(url);
  }
}
