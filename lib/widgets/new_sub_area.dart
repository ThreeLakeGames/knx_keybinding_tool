import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:provider/provider.dart';

class NewSubArea extends StatefulWidget {
  @override
  _NewSubAreaState createState() => _NewSubAreaState(editSubArea);

  final bool editSubArea;

  NewSubArea({this.editSubArea = false});
}

class _NewSubAreaState extends State<NewSubArea> {
  final bool isEditingSubArea;
  _NewSubAreaState(this.isEditingSubArea);
  final _form = GlobalKey<FormState>();
  SubAreaData newSubArea = SubAreaData(
    "",
    0,
    DateTime.now().toString(),
    [],
  );

  void _submitData() {
    final _isValid = _form.currentState.validate();
    _form.currentState.save();
    if (!_isValid) {
      return;
    }
    if (isEditingSubArea) {
      Provider.of<MainAreaData>(context, listen: false)
          .currentSubArea
          .setTitle(newSubArea.title);
    } else {
      newSubArea.index =
          Provider.of<MainAreaData>(context, listen: false).subAreas.length;

      Provider.of<MainAreaData>(context, listen: false)
          .addNewSubArea(newSubArea);
    }
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isEditingSubArea
                    ? Text("Bereich umbenennen")
                    : Text(
                        "Neuen Bereich hinzufügen",
                        // "add new sub-area",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            // fontSize: 18,
                            ),
                      ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: isEditingSubArea
                      ? Provider.of<MainAreaData>(context, listen: false)
                          .currentSubArea
                          .title
                      : "",
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Titel", hintText: "z.B. Erdgeschoss"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Bitte gültigen Titel eingeben";
                      // return "Plese Enter valid Title";
                    }
                    return null;
                  },
                  onSaved: (title) {
                    newSubArea.title = title;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  child: isEditingSubArea
                      ? Text("Bereich umbenennen")
                      : Text("Neuen Bereich hinzufügen"),
                  // child: Text("Add new area"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
