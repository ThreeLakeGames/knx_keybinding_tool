import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knx_keybinding_tool/models/project_basic_data.dart';

class ProjectsOverviewListItem extends StatelessWidget {
  final ProjectBasicData projectData;
  // final String projectID;
  // final String projectTitle;
  final Function openProject;

  ProjectsOverviewListItem({this.projectData, this.openProject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(projectData.projectTitle),
            Text(
                "Änderungsdatum: ${DateFormat.yMMMEd().format(projectData.latestModificationDate)}"),
          ],
        ),
        onTap: () {
          openProject(context, projectData.projectID);
        },
      ),
    );
  }
}
