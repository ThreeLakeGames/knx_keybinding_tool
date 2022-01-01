import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knx_keybinding_tool/models/project_basic_data.dart';
import 'package:knx_keybinding_tool/project/projects_overview_data.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewTable extends StatelessWidget {
  final Function openProject;

  ProjectsOverviewTable({this.openProject});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        elevation: 3,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(

              // horizontalMargin: 48,
              columns: _buildOverviewColumns(),
              rows: _buildOverviewItems(context)),
        ),
      ),
    );
  }

  List<DataColumn> _buildOverviewColumns() {
    TextStyle textStyle =
        TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.normal);
    return <DataColumn>[
      DataColumn(
        tooltip: "Projekt-Titel",
        label: Text("Titel", style: textStyle),
      ),
      DataColumn(
          tooltip: "Datum der letzten Änderung",
          label: Text(
            "Änderungsdatum",
            style: textStyle,
          )),
      DataColumn(
          label: Text(
        "ID",
        style: textStyle,
      )),
      DataColumn(label: Text("")),
      DataColumn(label: Text("")),
      DataColumn(label: Text("")),
    ];
  }

  List<DataRow> _buildOverviewItems(BuildContext ctx) {
    List<DataRow> projectItemRows = [];
    Provider.of<ProjectsOverviewData>(ctx, listen: false)
        .projects
        .forEach((projectBasicData) {
      projectItemRows.add(
        DataRow(
          cells: _buildProjectCells(projectBasicData, ctx),
        ),
      );
    });
    return projectItemRows;
  }

  List<DataCell> _buildProjectCells(
      ProjectBasicData projectBasicData, BuildContext ctx) {
    return <DataCell>[
      DataCell(
        Text(projectBasicData.projectTitle),
      ),
      DataCell(Text(
        DateFormat.yMMMd().format(projectBasicData.latestModificationDate),
      )),
      DataCell(Text(projectBasicData.projectID)),
      DataCell(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            decoration: BoxDecoration(
                color: Theme.of(ctx).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              "öffnen",
              style: TextStyle(color: Colors.white),
            ),
          ), onTap: () {
        openProject(ctx, projectBasicData.projectID);
      }),
      DataCell(Text("")),
      DataCell(Text("")),
    ];
  }
}
