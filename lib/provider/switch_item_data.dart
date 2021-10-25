import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

enum switchMode { sixButtons, fourButtons, twoButtons, singleRocker }

class SwitchItemData with ChangeNotifier {
  static const List<String> switchDesignNames = [
    "six rockers (2x3)",
    "four rockers (2x2)",
    "two rockers (2x1)",
    "single rocker"
  ];
  static Map<String, Vector2> switchTypes = {
    "six rockers (2x3)": Vector2(2, 3),
    "four rockers (2x2)": Vector2(2, 2),
    "two rockers vertical (1x2)": Vector2(1, 2),
    "two rockers horizontal(2x1)": Vector2(2, 1),
    "single rocker (1x1)": Vector2(1, 1),
  };

  int colSize = 2;
  int rowSize = 3;
  Vector2 rockerDimension = Vector2(2, 3);

  switchMode switchDesign;
  String id;

  List<String> rockerData = List<String>.generate(6, (index) => "");

  int get totalRockerSize {
    return (rockerDimension.x * rockerDimension.y).round();
  }
}
