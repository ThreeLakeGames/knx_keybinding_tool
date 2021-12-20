import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/screens/project_settings_screen.dart';
import 'package:knx_keybinding_tool/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class DefaultScreen extends StatelessWidget {
  final Function addNewArea;
  DefaultScreen(this.addNewArea);
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
      Provider.of<MainAreaData>(ctx, listen: false)
          .loadSubAreas()
          .then((value) => print("ended loading subarea ${DateTime.now()}"));
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
            Text("  Projekteinstellungen"),
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
            Text(" Bereich hinzufügen"),
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
