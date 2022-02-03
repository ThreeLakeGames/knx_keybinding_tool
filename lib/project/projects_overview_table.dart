import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/project_basic_data.dart';
import '../project/projects_overview_data.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewTable extends StatefulWidget {
  final Function openProject;
  final Function deleteProject;

  ProjectsOverviewTable({this.openProject, this.deleteProject});

  @override
  _ProjectsOverviewTableState createState() => _ProjectsOverviewTableState();
}

class _ProjectsOverviewTableState extends State<ProjectsOverviewTable> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      elevation: 3,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            // width: MediaQuery.of(context).size.width,
            child: DataTable(

                // horizontalMargin: 48,
                columns: _buildOverviewColumns(),
                rows: _buildOverviewItems(context)),
          ),
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
          tooltip: "Das Projekt existiert seit",
          label: Text(
            "Erstellungsdatum",
            style: textStyle,
          )),
      DataColumn(
          label: Text(
        "Schaltermaterial",
        style: textStyle,
      )),
      DataColumn(
          label: Text(
        "",
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
        onDoubleTap: () {
          widget.openProject(ctx, projectBasicData.projectID);
        },
      ),
      DataCell(
        Text(
          DateFormat.yMMMd().format(projectBasicData.latestModificationDate),
        ),
        onDoubleTap: () {
          widget.openProject(ctx, projectBasicData.projectID);
        },
      ),
      DataCell(
        Text(
          DateFormat.yMMMd().format(projectBasicData.creationDate),
        ),
        onDoubleTap: () {
          widget.openProject(ctx, projectBasicData.projectID);
        },
      ),
      DataCell(
        Text(projectBasicData.projectSwitchBrand),
        onDoubleTap: () {
          widget.openProject(ctx, projectBasicData.projectID);
        },
      ),
      DataCell(Text("")),
      _buildOpenButtonCell(projectBasicData, ctx),
      DataCell(Text("")),
      DataCell(Text("")),
    ];
  }

  DataCell _buildOpenButtonCell(
      ProjectBasicData projectBasicData, BuildContext ctx) {
    return DataCell(
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              decoration: BoxDecoration(
                  color: Theme.of(ctx).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(
                "öffnen",
                style: TextStyle(color: Colors.white),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (ctx) {
                return _popUpItems;
              },
              onSelected: (value) {
                if (value == "delete") {
                  widget.deleteProject(ctx, projectBasicData.projectID);
                }
              },
            ),

            // IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          ],
        ), onTap: () {
      widget.openProject(ctx, projectBasicData.projectID);
    });
  }

  final List<PopupMenuItem<String>> _popUpItems = [
    PopupMenuItem<String>(
      child: Row(
        children: [
          Icon(Icons.edit),
          Text("  Projekt bearbeiten"),
        ],
      ),
      value: "edit",
    ),
    PopupMenuItem<String>(
      child: Row(
        children: [
          Icon(Icons.delete),
          Text(" Projekt löschen"),
        ],
      ),
      value: "delete",
    ),
  ];
}
