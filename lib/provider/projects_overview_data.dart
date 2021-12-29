import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:knx_keybinding_tool/models/project_basic_data.dart';

class ProjectsOverviewData extends ChangeNotifier {
  List<ProjectBasicData> projects = [];

  Future<void> loadProjects() async {
    final url = Uri.parse(
        "https://knx-switchplanningtool-default-rtdb.europe-west1.firebasedatabase.app/.json");
    final response = await http.get(url);
    final loadedProjects = json.decode(response.body) as Map<String, dynamic>;
    // print(loadedProjects);
    loadedProjects.forEach((key, value) {
      final newProjectBasicData =
          ProjectBasicData(projectTitle: value["projectTitle"], projectID: key);
      projects.add(newProjectBasicData);
    });
  }
}
