import 'package:flutter/material.dart';

class ProjectsOverviewListItem extends StatelessWidget {
  final String projectID;
  final String projectTitle;
  final Function openProject;

  ProjectsOverviewListItem(
      {this.projectID, this.projectTitle, this.openProject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: ListTile(
        title: Text(projectTitle),
        subtitle: Text(projectID),
        onTap: () {
          openProject(context, projectID);
        },
      ),
    );
  }
}
