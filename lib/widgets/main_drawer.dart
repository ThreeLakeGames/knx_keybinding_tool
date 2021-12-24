import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  final Function addNewArea;
  final Function editSubArea;

  MainDrawer(this.addNewArea, {this.editSubArea});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            height: 80,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Text(
              "KNX - Tastenbelegung",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "RobotoCondensed",
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: constraints.maxHeight - 174,
            child: buildContentList(context),
          ),
          buildAddAreaButton(context),
        ],
      );
    }));
  }

  Widget buildSubAreaTile(String title, Function tapHandler,
      {bool isEditable = true,
      BuildContext context,
      IconData icon,
      SubAreaData subArea}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 2),
      key: UniqueKey(),
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          minVerticalPadding: 20.0,
          leading: Icon(icon),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "RobotoCondensed",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: isEditable ? _buildPopUpMenuButton(context, subArea) : null,
          onTap: tapHandler,
        ),
      ),
    );
  }

  Widget buildAddAreaButton(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.shade100,
            blurRadius: 7.0,
          ),
        ],
      ),
      height: 70,
      child: Card(
        elevation: 7,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          minVerticalPadding: 20.0,
          leading: Icon(
            Icons.add,
          ),
          title: Text(
            "Bereich hinzufügen",
            style: TextStyle(
              fontFamily: "RobotoCondensed",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.of(ctx).pop();
            widget.addNewArea(ctx);
          },
        ),
      ),
    );
  }

  Widget buildContentList(BuildContext ctx) {
    return ReorderableListView(
      buildDefaultDragHandles: true,
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          Provider.of<MainAreaData>(ctx, listen: false)
              .updateSubAreaListView(oldIndex, newIndex);
        });
      },
      children: buildSubAreaItems(ctx),
    );
  }

  List<Widget> buildSubAreaItems(BuildContext ctx) {
    List<Widget> overviewAreaList = [];
    final mainAreaData = Provider.of<MainAreaData>(ctx);

    mainAreaData.subAreas.forEach((overviewArea) {
      overviewAreaList.add(buildSubAreaTile(
        overviewArea.title,
        () {
          //if tile is clicked -> the current shown overview Area changes (by index-changing)
          mainAreaData.setOverviewAreaIndex(overviewArea.index);
          Navigator.of(ctx).pop();
        },
        context: ctx,
        icon: Icons.home,
        subArea: overviewArea,
      ));
      // overviewAreaList.add(Divider());
    });
    return overviewAreaList;
  }

  Widget _buildPopUpMenuButton(BuildContext context, SubAreaData subArea) {
    return PopupMenuButton<String>(
      itemBuilder: (ctx) {
        return [
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
        ];
      },
      onSelected: (value) {
        if (value == "delete") {
          Provider.of<MainAreaData>(context, listen: false)
              .deleteSubArea(subArea);
        } else if (value == "editSubArea") {
          widget.editSubArea(context, subArea);
        }
      },
    );
  }
}



//   List<Widget> buildOverviewAreaList(BuildContext ctx) {
//     List<Widget> overviewAreaList = [];
//     final overviewProvider = Provider.of<OverviewAreasProvider>(ctx);

//     overviewProvider.overviewAreaList.forEach((overviewArea) {
//       overviewAreaList.add(buildListTile(
//         overviewArea.title,
//         Icons.home,
//         () {
//           //if tile is clicked -> the current shown overview Area changes (by index-changing)
//           overviewProvider.setOverviewAreaByID(overviewArea.id);
//           Navigator.of(ctx).pop();
//         },
//       ));
//       overviewAreaList.add(Divider());
//     });
//     return overviewAreaList;
//   }
// }
