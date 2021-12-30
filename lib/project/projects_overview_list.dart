import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/project/projects_overview_data.dart';
import 'package:knx_keybinding_tool/project/projects_overview_list_item.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewList extends StatelessWidget {
  final Function openProject;

  ProjectsOverviewList({this.openProject});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 20),
        Text(
          "Projekte:",
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 10),
        ..._buildOverviewListItems(context),
      ],
    );
  }

  List<ProjectsOverviewListItem> _buildOverviewListItems(BuildContext ctx) {
    final projectsOverviewData = Provider.of<ProjectsOverviewData>(ctx);
    List<ProjectsOverviewListItem> overviewListItems = [];

    projectsOverviewData.projects.forEach((projectBasicData) {
      overviewListItems.add(
        ProjectsOverviewListItem(
          projectData: projectBasicData,
          openProject: openProject,
        ),
      );
    });
    return overviewListItems;
  }
}
