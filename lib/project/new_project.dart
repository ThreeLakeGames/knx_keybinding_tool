import 'package:flutter/material.dart';
import '../provider/main_area_data.dart';
import '../project/projects_overview_data.dart';
import 'package:provider/provider.dart';

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final _form = GlobalKey<FormState>();
  MainAreaData newProject = MainAreaData("", creationDate: DateTime.now());

  void _submitData() async {
    final _isValid = _form.currentState.validate();
    _form.currentState.save();
    if (!_isValid) {
      return;
    }
    await Provider.of<ProjectsOverviewData>(context, listen: false)
        .addNewProject(newProject)
        .then((_) {
      Navigator.of(context).pop();
    });
    // exitNewProjectScreen();
  }

  void exitNewProjectScreen() {
    Navigator.of(context).pop();
  }

  @override
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
                  "Neues Projekt erstellen",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Titel", hintText: "KNX-Projekt"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Bitte gültigen Titel eingeben";
                    }
                    return null;
                  },
                  onSaved: (title) {
                    newProject.projectName = title;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text("Neues Projekt hinzufügen"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
