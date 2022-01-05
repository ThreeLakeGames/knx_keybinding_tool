import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/project/projects_overview_table.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/project/projects_overview_data.dart';
import 'package:knx_keybinding_tool/screens/main_overview_screen.dart';
import 'package:knx_keybinding_tool/project/new_project.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewScreen extends StatefulWidget {
  static const routeName = "/projects-overview-screen";

  @override
  _ProjectsOverviewScreenState createState() => _ProjectsOverviewScreenState();
}

class _ProjectsOverviewScreenState extends State<ProjectsOverviewScreen> {
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  bool isLoading = true;

  @override
  void initState() {
    Provider.of<ProjectsOverviewData>(context, listen: false)
        .loadProjects()
        .then((_) => finishedLoading());
    super.initState();
  }

  void _startAddNewProject(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewProject();
      },
    ).then(onGoBack);
  }

  void finishedLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void openProject(BuildContext ctx, String projectID) {
    Provider.of<MainAreaData>(ctx, listen: false)
        .loadProject(projectID)
        .then((_) {
      Navigator.of(ctx).pushNamed(MainOverviewScreen.routeName).then(onGoBack);
    });
  }

  void deleteProject(BuildContext ctx, String projectID) {
    Provider.of<ProjectsOverviewData>(ctx, listen: false)
        .deleteProject(projectID)
        .then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KNX - Projekte"),
      ),
      body: isLoading
          ? Center(
              child: Text("Noch keine Projekte erstellt"),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Projekte",
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                ProjectsOverviewTable(
                  openProject: openProject,
                  deleteProject: deleteProject,
                ),
              ],
            ),
      // : ProjectsOverviewList(
      //     openProject: openProject,
      //   ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewProject(context);
        },
      ),
    );
  }
}
