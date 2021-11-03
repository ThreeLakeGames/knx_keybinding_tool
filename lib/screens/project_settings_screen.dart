import 'package:flutter/material.dart';

class ProjectSettingsScreen extends StatelessWidget {
  static const String projectName = "/project-settings-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Settings"),
      ),
      body: Center(
        child: Text("project Settings"),
      ),
    );
  }
}
