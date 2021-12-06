import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart';

import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';

class NewSwitch extends StatefulWidget {
  @override
  _NewSwitchState createState() => _NewSwitchState();
}

class _NewSwitchState extends State<NewSwitch> {
  static const MAX_COMBINATION_LENGTH = 4;
  final _form = GlobalKey<FormState>();
  int _selectedCombinationLength = 1;
  var newSwitchCombinationData = SwitchCombinationItemData(
    "",
    List<SwitchItemData>.generate(
        MAX_COMBINATION_LENGTH, (index) => SwitchItemData()),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              width: constraints.maxWidth,
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Neuen Schalter hinzufügen"),
                    // Text("Add new Switch"),
                    TextFormField(
                      autofocus: true,
                      decoration: InputDecoration(labelText: "Titel"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Bitte gültigen Titel eingeben";
                          // return "Plese Enter valid Title";
                        }
                        return null;
                      },
                      onSaved: (title) {
                        newSwitchCombinationData.title = title;
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("Schalter-Anzahl"),
                    // Text("Combination Size:"),
                    DropdownButtonFormField(
                      items: _switchCombinationLengthItems,
                      value: _selectedCombinationLength,
                      onChanged: (val) {
                        setState(() {
                          _selectedCombinationLength = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: _buildSwitchSizeButtons(constraints),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text("Schalter hinzufügen"),
                      // child: Text("Add new switch"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitData() {
    final _isValid = _form.currentState.validate();
    _form.currentState.save();
    if (!_isValid) {
      return;
    }
    newSwitchCombinationData.switchList = newSwitchCombinationData.switchList
        .sublist(0, _selectedCombinationLength);
    Provider.of<MainAreaData>(context, listen: false)
        .currentSubArea
        .addSwitchCombination(newSwitchCombinationData);
    Navigator.of(context).pop();
  }

  List<DropdownMenuItem<int>> get _switchCombinationLengthItems {
    List<DropdownMenuItem<int>> combinationLengthItems = [];
    for (int i = 1; i <= MAX_COMBINATION_LENGTH; i++) {
      combinationLengthItems.add(DropdownMenuItem<int>(
          child: Text(
            i.toString(),
          ),
          value: i));
    }
    return combinationLengthItems;
  }

  List<DropdownMenuItem<Vector2>> get _switchTypesItems {
    List<DropdownMenuItem<Vector2>> dropdownItems = [];
    SwitchItemData.switchTypes.forEach((name, value) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(name),
        value: value,
      ));
    });
    return dropdownItems;
  }

  List<Widget> _buildSwitchSizeButtons(BoxConstraints constraints) {
    List<Widget> switchSizeButtons = [];

    for (int i = 0; i < _selectedCombinationLength; i++) {
      switchSizeButtons.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Schalter ${i + 1}  "),
            Container(
              width: constraints.maxWidth * 0.8,
              child: DropdownButtonFormField<Vector2>(
                items: _switchTypesItems,
                value: _switchTypesItems[0].value,
                onChanged: (val) {
                  newSwitchCombinationData.switchList[i].rockerDimension = val;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }
    return switchSizeButtons;
  }
}
