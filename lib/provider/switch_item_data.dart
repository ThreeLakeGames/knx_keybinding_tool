import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

enum switchMode { sixButtons, fourButtons, twoButtons, singleRocker }

class SwitchItemData with ChangeNotifier {
  static Map<String, Vector2> switchTypes = {
    "6 Tasten (2x3)": Vector2(2, 3),
    "4 Tasten (2x2)": Vector2(2, 2),
    "2 Tasten-übereinander (1x2)": Vector2(1, 2),
    "2 Tasten-nebeneinander(2x1)": Vector2(2, 2),
    "Einzeltaste (1x1)": Vector2(1, 2),
    "Bewgungsmelder": Vector2(1, 2),
    // "six rockers (2x3)": Vector2(2, 3),
    // "four rockers (2x2)": Vector2(2, 2),
    // "two rockers vertical (1x2)": Vector2(1, 2),
    // "two rockers horizontal(2x1)": Vector2(2, 1),
    // "single rocker (1x1)": Vector2(1, 1),
  };

  int colSize = 2;
  int rowSize = 3;
  Vector2 rockerDimension = Vector2(2, 3);

  String switchType = "6 Tasten (2x3)";
  String imageUrl = "assets/switchImages/Berker/3-Wippen.jpg";
  switchMode switchDesign;
  String id;

  List<String> rockerData = List<String>.generate(6, (index) => "");
  SwitchItemData();
  SwitchItemData.withValues(
      this.rockerData, this.rockerDimension, this.switchType);

  int get totalRockerSize {
    return (rockerDimension.x * rockerDimension.y).round();
  }

  void setSwitchType(String switchType) {
    this.switchType = switchType;
  }

// assign right dimension + image_path to each switch type
  void updateSwitchType(String currentBrand) {
    switch (switchType) {
      case "6 Tasten (2x3)":
        rockerDimension = Vector2(2, 3);
        imageUrl = "assets/switchImages/$currentBrand/3-Wippen.jpg";
        break;
      case "4 Tasten (2x2)":
        rockerDimension = Vector2(2, 2);
        imageUrl = "assets/switchImages/$currentBrand/2-Wippen_V.jpg";
        break;
      case "2 Tasten-übereinander (1x2)":
        rockerDimension = Vector2(1, 2);
        imageUrl = "assets/switchImages/$currentBrand/2-Wippen_V.jpg";
        break;
      case "2 Tasten-nebeneinander(2x1)":
        rockerDimension = Vector2(2, 2);
        imageUrl = "assets/switchImages/$currentBrand/2-Wippen_H.jpg";
        break;
      case "Einzeltaste (1x1)":
        rockerDimension = Vector2(1, 2);
        imageUrl = "assets/switchImages/$currentBrand/1-Wippe.jpg";
        break;
      case "Bewgungsmelder":
        rockerDimension = Vector2(1, 2);
        imageUrl = "assets/switchImages/$currentBrand/BWM.jpg";
        break;
    }
  }

  // function for saving the switch to server
  Map<String, dynamic> getSwitchMetaData() {
    return {
      "colCount": rockerDimension.x,
      "rowCount": rockerDimension.y,
      "rockerData": getRockerData(),
      "switchType": switchType,
    };
  }

  List<String> getRockerData() {
    return rockerData;
  }
}
