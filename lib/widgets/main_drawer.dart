import 'dart:js';

import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  final Function addNewArea;
  final Function editSubArea;

  MainDrawer(this.addNewArea, {this.editSubArea});
  Widget buildListTile(String title, Function tapHandler,
      {bool isEditable = true,
      BuildContext context,
      IconData icon,
      SubAreaData subArea}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: isEditable ? _buildPopUpMenuButton(context, subArea) : null,
      onTap: tapHandler,
    );
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
          editSubArea(context, subArea);
        }
      },
    );
  }

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
            height: constraints.maxHeight - 104,
            child: buildContentList(context),
          )
        ],
      );
    }));
  }

  Widget buildContentList(BuildContext ctx) {
    return ListView(
      children: [
        Column(
          children: buildSubAreaItems(ctx),
        ),
        buildListTile(
          "Bereich hinzufügen",
          // "add area",
          () {
            Navigator.of(ctx).pop();
            addNewArea(ctx);
          },
          context: ctx,
          icon: Icons.add,
          isEditable: false,
        ),
        Divider(),
      ],
    );
  }

  List<Widget> buildSubAreaItems(BuildContext ctx) {
    List<Widget> overviewAreaList = [];
    final mainAreaData = Provider.of<MainAreaData>(ctx);

    mainAreaData.subAreas.forEach((overviewArea) {
      overviewAreaList.add(buildListTile(
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
      overviewAreaList.add(Divider());
    });
    return overviewAreaList;
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
