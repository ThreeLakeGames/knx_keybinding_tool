import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/widgets/main_drawer.dart';
import 'package:knx_keybinding_tool/widgets/new_sub_area.dart';
import 'package:knx_keybinding_tool/widgets/new_switch.dart';
import 'package:knx_keybinding_tool/widgets/sub_area_overview.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MainOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainAreaData = Provider.of<MainAreaData>(context);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(child: pw.Text("Hallo"));
        },
      ),
    );
    pdf.save();

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                _handlePopUpMenuButton(context, value);
              },
              itemBuilder: (ctx) => appBarItems(context))
        ],
        title:
            Text("KNX - Tastenbelegung - " + mainAreaData.currentSubArea.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewSwitch(context);
        },
      ),
      drawer: MainDrawer(_startAddNewArea),
      body: IndexedStack(
        children: _buildSubAreaItems(context),
        index: mainAreaData.currentSubAreaIndex,
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
    } else if (value == "delete") {
      Provider.of<MainAreaData>(ctx, listen: false).deleteCurrentSubArea();
    }
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

  List<PopupMenuItem> appBarItems(BuildContext context) {
    return [
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            Text("  edit sub-area"),
          ],
        ),
        value: "edit",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.black87,
            ),
            Text(" delete sub-area"),
          ],
        ),
        value: "delete",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.black87,
            ),
            Text(" add new sub-area"),
          ],
        ),
        value: "addSubArea",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.print,
              color: Colors.black87,
            ),
            Text(" export project"),
          ],
        ),
        value: "export",
      ),
    ];
  }
}
