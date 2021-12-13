import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  final Function addNewArea;

  MainDrawer(this.addNewArea);
  Widget buildListTile(String title, IconData icon, Function tapHandler,
      {bool isEditable = true}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: isEditable
          ? IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
          : null,
      onTap: tapHandler,
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

  Widget buildContentList(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: buildSubAreaItems(context),
        ),
        buildListTile(
          "Bereich hinzufügen",
          // "add area",
          Icons.add,
          () {
            Navigator.of(context).pop();
            addNewArea(context);
          },
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
        Icons.home,
        () {
          //if tile is clicked -> the current shown overview Area changes (by index-changing)
          mainAreaData.setOverviewAreaIndex(overviewArea.index);
          Navigator.of(ctx).pop();
        },
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
