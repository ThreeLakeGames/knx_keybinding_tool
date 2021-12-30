import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/projects_overview_data.dart';
import 'package:knx_keybinding_tool/widgets/projects_overview_list_item.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewList extends StatelessWidget {
  final Function openProject;

  ProjectsOverviewList({this.openProject});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildOverviewListItems(context),
    );
  }

  List<ProjectsOverviewListItem> _buildOverviewListItems(BuildContext ctx) {
    final projectsOverviewData = Provider.of<ProjectsOverviewData>(ctx);
    List<ProjectsOverviewListItem> overviewListItems = [];

    projectsOverviewData.projects.forEach((projectBasicData) {
      overviewListItems.add(
        ProjectsOverviewListItem(
          projectID: projectBasicData.projectID,
          projectTitle: projectBasicData.projectTitle,
          openProject: openProject,
        ),
      );
    });
    return overviewListItems;
  }
}
