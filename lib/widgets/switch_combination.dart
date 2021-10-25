import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:knx_keybinding_tool/widgets/switch_item.dart';
import 'package:provider/provider.dart';

class SwitchCombination extends StatefulWidget {
  @override
  _SwitchCombinationState createState() => _SwitchCombinationState();
}

class _SwitchCombinationState extends State<SwitchCombination> {
  bool _isTitleEditing = false;
  FocusNode titleTextFocus;

  List<PopupMenuItem<String>> _popUpItems = [
    PopupMenuItem<String>(
      child: Row(
        children: [
          Icon(Icons.settings),
          Text("  edit"),
        ],
      ),
      value: "edit",
    ),
    PopupMenuItem<String>(
      child: Row(
        children: [
          Icon(Icons.delete),
          Text(" delete"),
        ],
      ),
      value: "delete",
    ),
  ];
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
    final switchCombinationData =
        Provider.of<SwitchCombinationItemData>(context);
    final switchList =
        Provider.of<SwitchCombinationItemData>(context).switchList;
    return Container(
      width: 225,
      child: Column(
        children: [
          _buildTitle(switchCombinationData),
          FocusScope(
            onKey: (focusNode, keyEvent) {
              return handleKeyboardRockerFocus(focusNode, keyEvent);
            },
            child: Column(
              children: _buildSwitchItems(switchList),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSwitchItems(List<SwitchItemData> switchList) {
    List<Widget> switchItemList = [];
    switchList.forEach(
      (switchItemData) {
        switchItemList.add(
          ChangeNotifierProvider.value(
            value: switchItemData,
            child: Column(
              children: [
                SwitchItem(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
    return switchItemList;
  }

  Widget _buildTitle(SwitchCombinationItemData switchCombinationData) {
    return Focus(
      autofocus: false,
      onFocusChange: (isFocused) {
        setState(() {
          _isTitleEditing = isFocused;
        });
      },
      child: _isTitleEditing
          ? TextFormField(
              focusNode: titleTextFocus,
              autofocus: true,
              textAlign: TextAlign.center,
              initialValue: switchCombinationData.title,
              onChanged: (value) {
                switchCombinationData.title = value;
              },
              onEditingComplete: () {
                setState(() {
                  _isTitleEditing = false;
                });
              },
            )
          : Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      titleTextFocus.requestFocus();
                      setState(() {
                        _isTitleEditing = true;
                      });
                    },
                    child: Text(
                      switchCombinationData.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  itemBuilder: (context) {
                    return _popUpItems;
                  },
                  onSelected: (value) {
                    popUpMenuSelected(value);
                  },
                )
              ],
            ),
    );
  }

  void popUpMenuSelected(String value) {
    // delete Switch
    if (value == "delete") {
      Provider.of<SubAreaData>(context, listen: false).deleteSwitchCombination(
          Provider.of<SwitchCombinationItemData>(context, listen: false));
    }
  }

// handle focus movement due keyboard arrows
  KeyEventResult handleKeyboardRockerFocus(focusNode, keyEvent) {
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      focusNode.focusInDirection(TraversalDirection.down);
      return KeyEventResult.handled;
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      focusNode.focusInDirection(TraversalDirection.up);
      return KeyEventResult.handled;
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      focusNode.focusInDirection(TraversalDirection.right);
      return KeyEventResult.handled;
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      focusNode.focusInDirection(TraversalDirection.left);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

// -------------------------PDF---------------------------------

}
