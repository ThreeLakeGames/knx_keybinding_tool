import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../project/projects_overview_data.dart';
import './project_settings_screen.dart';
import '../widgets/main_drawer.dart';

class DefaultProjectScreen extends StatelessWidget {
  final Function addNewArea;
  DefaultProjectScreen(this.addNewArea);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KNX - Tastenbelegungsplaner"),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                _handlePopUpMenuButton(context, value);
              },
              itemBuilder: (ctx) => appBarItems(context))
        ],
      ),
      drawer: MainDrawer(addNewArea),
      body: Center(
        child: Text("Noch keine Unterbereiche erstellt!"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addNewArea(context);
        },
      ),
    );
  }

  // FutureOr onGoBack(dynamic value) {
  //   setState(() {});
  // }

  void _handlePopUpMenuButton(BuildContext ctx, String value) {
    if (value == "addSubArea") {
      addNewArea(ctx);
    } else if (value == "project-settings") {
      Navigator.of(ctx).pushNamed(ProjectSettingsScreen.routeName);
    } else if (value == "load") {
      Provider.of<ProjectsOverviewData>(ctx, listen: false).loadProjects();
      // Provider.of<MainAreaData>(ctx, listen: false)
      //     .loadSubAreas()
      //     .then((value) => print("ended loading subarea ${DateTime.now()}"));
    }
  }

  List<PopupMenuItem> appBarItems(BuildContext context) {
    return [
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            Text("  Projekt-Einstellungen"),
            // Text("  project settings"),
          ],
        ),
        value: "project-settings",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.black87,
            ),
            Text(" Bereich hinzuf??gen"),
            // Text(" add new sub-area"),
          ],
        ),
        value: "addSubArea",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.download,
              color: Colors.black87,
            ),
            Text(" Projekt laden"),
            // Text(" load project"),
          ],
        ),
        value: "load",
      ),
    ];
  }
}
