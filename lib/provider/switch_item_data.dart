import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

enum switchMode { sixButtons, fourButtons, twoButtons, singleRocker }

class SwitchItemData with ChangeNotifier {
  static const Map<String, String> BERKER_IMAGE_PATHS = {
    "6 Tasten (2x3)": "assets/switchImages/Berker/BERKER_3-Wippen.jpg",
    "4 Tasten (2x2)": "assets/switchImages/Berker/BERKER_2-Wippen_V.jpg",
    "2 Tasten-übereinander (1x2)":
        "assets/switchImages/Berker/BERKER_2-Wippen_V.jpg",
    "2 Tasten-nebeneinander(2x1)":
        "assets/switchImages/Berker/BERKER_2-Wippen_V.jpg",
    "Einzeltaste (1x1)": "assets/switchImages/Berker/BERKER_1-Wippe.jpg",
  };
  static const List<String> switchDesignNames = [
    "six rockers (2x3)",
    "four rockers (2x2)",
    "two rockers (2x1)",
    "single rocker"
  ];
  static Map<String, Vector2> switchTypes = {
    "6 Tasten (2x3)": Vector2(2, 3),
    "4 Tasten (2x2)": Vector2(2, 2),
    "2 Tasten-übereinander (1x2)": Vector2(1, 2),
    "2 Tasten-nebeneinander(2x1)": Vector2(2, 1),
    "Einzeltaste (1x1)": Vector2(1, 1),
    // "six rockers (2x3)": Vector2(2, 3),
    // "four rockers (2x2)": Vector2(2, 2),
    // "two rockers vertical (1x2)": Vector2(1, 2),
    // "two rockers horizontal(2x1)": Vector2(2, 1),
    // "single rocker (1x1)": Vector2(1, 1),
  };

  int colSize = 2;
  int rowSize = 3;
  Vector2 rockerDimension = Vector2(2, 3);

  switchMode switchDesign;
  String id;

  List<String> rockerData = List<String>.generate(6, (index) => "");
  SwitchItemData();
  SwitchItemData.withValues(this.rockerData, this.rockerDimension);

  int get totalRockerSize {
    return (rockerDimension.x * rockerDimension.y).round();
  }

  // function for saving the switch to server
  Map<String, dynamic> getSwitchMetaData() {
    return {
      "colCount": rockerDimension.x,
      "rowCount": rockerDimension.y,
      "rockerData": getRockerData(),
    };
  }

  List<String> getRockerData() {
    return rockerData;
  }
}
