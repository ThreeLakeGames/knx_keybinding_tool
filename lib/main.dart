import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/main_area_data.dart';
import 'package:knx_keybinding_tool/screens/main_overview_screen.dart';
import 'package:knx_keybinding_tool/screens/pdf_preview_screen.dart';
import 'package:knx_keybinding_tool/screens/project_settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainAreaData("IFK Salzburg"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tastenbelegungsplaner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // textTheme: TextTheme(headline1: TextStyle())
        ),
        home: MainOverviewScreen(),
        routes: {
          PdfPreviewScreen.routeName: (ctx) => PdfPreviewScreen(),
          ProjectSettingsScreen.routeName: (ctx) => ProjectSettingsScreen(),
        },
      ),
    );
  }
}
