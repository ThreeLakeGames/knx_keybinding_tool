import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/projects_overview_data.dart';
import 'package:knx_keybinding_tool/widgets/projects_overview_list.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewScreen extends StatefulWidget {
  static const routeName = "/projects-overview-screen";

  @override
  _ProjectsOverviewScreenState createState() => _ProjectsOverviewScreenState();
}

class _ProjectsOverviewScreenState extends State<ProjectsOverviewScreen> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    print("changed Dependencies");
    super.didChangeDependencies();
  }

  FutureOr onGoBack(dynamic value) {
    print("ON GO BACK   ProjectOverviewScreen");
    setState(() {});
  }

  @override
  void initState() {
    Provider.of<ProjectsOverviewData>(context, listen: false)
        .loadProjects()
        .then((_) => finishedLoading());
    super.initState();
  }

  void finishedLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KNX-Tastenbelegungsplaner"),
      ),
      body: isLoading
          ? Center(
              child: Text("Noch keine Projekte erstellt"),
            )
          : ProjectsOverviewList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
