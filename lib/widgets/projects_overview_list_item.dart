import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/screens/main_overview_screen.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewListItem extends StatelessWidget {
  final String projectID;
  final String projectTitle;
  final Function onGoBack;

  ProjectsOverviewListItem({this.projectID, this.projectTitle, this.onGoBack});

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

  void openProject(BuildContext ctx, String projectID) {
    Provider.of<MainAreaData>(ctx, listen: false)
        .loadProject(projectID)
        .then((_) {
      print("then...");
      Navigator.of(ctx).pushNamed(MainOverviewScreen.routeName);
    });
  }
}
