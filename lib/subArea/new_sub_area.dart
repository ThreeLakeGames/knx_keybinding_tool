import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/subArea/sub_area_data.dart';
import 'package:provider/provider.dart';

class NewSubArea extends StatefulWidget {
  @override
  _NewSubAreaState createState() => _NewSubAreaState(editSubArea);

  final bool editSubArea;
  final SubAreaData editedSubAreaData;

  NewSubArea({
    this.editSubArea = false,
    this.editedSubAreaData,
  });
}

class _NewSubAreaState extends State<NewSubArea> {
  final bool isEditingSubArea;
  final _form = GlobalKey<FormState>();
  SubAreaData newSubArea = SubAreaData("", 0, DateTime.now().toString(), []);

  _NewSubAreaState(this.isEditingSubArea);

  void _submitData() {
    final _isValid = _form.currentState.validate();
    _form.currentState.save();
    if (!_isValid) {
      return;
    }
    if (isEditingSubArea) {
      widget.editedSubAreaData.setTitle(newSubArea.title);
    } else {
      final mainAreaData = Provider.of<MainAreaData>(context, listen: false);
      newSubArea.index = mainAreaData.subAreas.length;
      mainAreaData.currentSubAreaIndex = mainAreaData.subAreas.length;
      mainAreaData.addNewSubArea(newSubArea);
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
                    ? Text(
                        "Bereich umbenennen",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        "Neuen Bereich hinzufügen",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue:
                      isEditingSubArea ? widget.editedSubAreaData.title : "",
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Titel", hintText: "z.B. Erdgeschoss"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Bitte gültigen Titel eingeben";
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
