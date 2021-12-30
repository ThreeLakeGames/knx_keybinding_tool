import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knx_keybinding_tool/models/project_basic_data.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';

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
      );
      projects.add(newProjectBasicData);
    });
  }

  Future<void> addNewProject(MainAreaData newProject) async {
    await newProject.storeProjectData();
    final newProjectsBasicData = ProjectBasicData(
        projectID: newProject.projectID, projectTitle: newProject.projectName);
    projects.add(newProjectsBasicData);
  }
}
