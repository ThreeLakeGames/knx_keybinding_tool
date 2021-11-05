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
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return Column(
              children: [
                Row(
                  children: [
                    Text("project title:    "),
                    Container(
                      width: constraints.maxWidth * 0.3,
                      child: _buildTitle(mainAreaData),
                    ),
                  ],
                ),
              ],
            );
          },
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
              children: [
                TextButton(
                  onPressed: () {
                    titleTextFocus.requestFocus();
                    setState(() {
                      _isTitleEditing = true;
                    });
                  },
                  child: Text(
                    mainAreaData.projectName,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
    );
  }
}
