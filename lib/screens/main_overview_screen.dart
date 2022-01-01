import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/project/projects_overview_data.dart';
import 'package:knx_keybinding_tool/subArea/sub_area_data.dart';
import 'package:knx_keybinding_tool/screens/pdf_preview_screen.dart';
import 'package:knx_keybinding_tool/screens/project_settings_screen.dart';
import 'package:knx_keybinding_tool/widgets/main_drawer.dart';
import 'package:knx_keybinding_tool/subArea/new_sub_area.dart';
import 'package:knx_keybinding_tool/switch/new_switch.dart';
import 'package:knx_keybinding_tool/subArea/sub_area_overview.dart';
import 'package:provider/provider.dart';

class MainOverviewScreen extends StatefulWidget {
  static const routeName = "/project-screen";
  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen> {
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  //update Screen after returning from settings-screen
  FutureOr onGoBackSettings(dynamic value) {
    storeProject();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mainAreaData = Provider.of<MainAreaData>(context);
    bool isEmpty = mainAreaData.subAreas.isEmpty;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                _handlePopUpMenuButton(context, value);
              },
              itemBuilder: (ctx) => appBarItems(context)),
          IconButton(
            onPressed: closeProject,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
        title: isEmpty
            ? Text(mainAreaData.projectName)
            : Text(mainAreaData.projectName +
                " - " +
                mainAreaData.currentSubArea.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (isEmpty) {
            _startAddNewArea(context);
          } else {
            _startAddNewSwitch(context);
          }
        },
      ),
      drawer: MainDrawer(
        _startAddNewArea,
        editSubArea: _startEditArea,
      ),
      body: isEmpty
          ? Center(
              child: Text("Noch keine Unterbereiche erstellt..."),
            )
          : mainAreaData.isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: IndexedStack(
                    children: _buildSubAreaItems(context),
                    index: mainAreaData.currentSubAreaIndex,
                  ),
                ),
    );
  }

  List<Widget> _buildSubAreaItems(BuildContext context) {
    List<Widget> subAreaItems = [];

    Provider.of<MainAreaData>(context).subAreas.forEach(
      (subArea) {
        subAreaItems.add(
          ChangeNotifierProvider.value(
            value: subArea,
            child: SubAreaOverview(),
          ),
        );
      },
    );
    return subAreaItems;
  }

  void _handlePopUpMenuButton(BuildContext ctx, String value) {
    if (value == "addSubArea") {
      _startAddNewArea(ctx);
    } else if (value == "editSubArea") {
      _startEditArea(
          ctx, Provider.of<MainAreaData>(ctx, listen: false).currentSubArea);
    } else if (value == "delete") {
      Provider.of<MainAreaData>(ctx, listen: false).deleteCurrentSubArea();
    } else if (value == "export") {
      Navigator.of(context).pushNamed(PdfPreviewScreen.routeName);
    } else if (value == "project-settings") {
      Navigator.of(context)
          .pushNamed(ProjectSettingsScreen.routeName)
          .then(onGoBackSettings);
    } else if (value == "save") {
      storeProject();
    } else if (value == "load") {}
  }

  void storeProject() {
    Provider.of<MainAreaData>(context, listen: false).storeProjectData();
  }

  void _startAddNewSwitch(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewSwitch();
      },
    );
  }

  void _startAddNewArea(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewSubArea();
      },
    );
  }

  void _startEditArea(BuildContext ctx, SubAreaData subArea) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewSubArea(
          editSubArea: true,
          editedSubAreaData: subArea,
        );
      },
    ).then(onGoBack);
  }

  void closeProject() {
    storeProject();
    Provider.of<ProjectsOverviewData>(context, listen: false)
        .loadProjects()
        .then((_) {
      Navigator.of(context).pop();
    });
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
              Icons.print,
              color: Colors.black87,
            ),
            Text(" Projekt exportieren (PDF)"),
            // Text(" export project"),
          ],
        ),
        value: "export",
      ),
      PopupMenuItem<String>(
        enabled: true,
        child: Row(
          children: [
            Icon(
              Icons.save,
              color: Colors.black87,
            ),
            Text(" Projekt speichern"),
            // Text(" save project"),
          ],
        ),
        value: "save",
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
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.black87,
            ),
            Text(" Bereich löschen"),
            // Text(" delete sub-area"),
          ],
        ),
        value: "delete",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Colors.black87,
            ),
            Text(" Bereich umbenennen"),
            // Text(" add new sub-area"),
          ],
        ),
        value: "editSubArea",
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
    ];
  }
}
