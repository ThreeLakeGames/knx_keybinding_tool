import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/provider/sub_area_data.dart';
import 'package:provider/provider.dart';

class NewSubArea extends StatefulWidget {
  @override
  _NewSubAreaState createState() => _NewSubAreaState();
}

class _NewSubAreaState extends State<NewSubArea> {
  final _form = GlobalKey<FormState>();
  SubAreaData newSubArea = SubAreaData(
    "",
    0,
    DateTime.now().toString(),
  );
  @override
  void _submitData() {
    final _isValid = _form.currentState.validate();
    _form.currentState.save();
    if (!_isValid) {
      return;
    }
    newSubArea.index =
        Provider.of<MainAreaData>(context, listen: false).subAreas.length;

    Provider.of<MainAreaData>(context, listen: false).addNewSubArea(newSubArea);
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
                Text(
                  "add new sub-area",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      // fontSize: 18,
                      ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Title", hintText: "z.B. Erdgeschoss"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Plese Enter valid Title";
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
                  child: Text("Add new area"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
