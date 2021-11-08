import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:provider/provider.dart';

class ProjectSettingsScreen extends StatefulWidget {
  static const String routeName = "/project-settings-screen";

  @override
  _ProjectSettingsScreenState createState() => _ProjectSettingsScreenState();
}

class _ProjectSettingsScreenState extends State<ProjectSettingsScreen> {
  bool _isTitleEditing = false;
  FocusNode titleTextFocus;
  @override
  void initState() {
    titleTextFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleTextFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainAreaData = Provider.of<MainAreaData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(mainAreaData.projectName + " - Project Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                children: [
                  Text(
                    " Project - Settings  ",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (ctx, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "project title:    ",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // width: constraints.maxWidth * 0.3,
                            child: _buildTitle(mainAreaData),
                          ),
                        ],
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(MainAreaData mainAreaData) {
    return Focus(
      autofocus: false,
      onFocusChange: (isFocused) {
        setState(() {
          _isTitleEditing = isFocused;
        });
      },
      child: _isTitleEditing
          ? TextFormField(
              maxLength: 50,
              focusNode: titleTextFocus,
              autofocus: true,
              textAlign: TextAlign.start,
              initialValue: mainAreaData.projectName,
              onChanged: (value) {
                mainAreaData.projectName = value;
              },
              onEditingComplete: () {
                setState(() {
                  _isTitleEditing = false;
                });
              },
            )
          : Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    mainAreaData.projectName,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    titleTextFocus.requestFocus();
                    setState(() {
                      _isTitleEditing = true;
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
    );
  }
}
