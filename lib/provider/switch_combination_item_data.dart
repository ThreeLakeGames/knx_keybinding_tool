import 'package:flutter/cupertino.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';

class SwitchCombinationItemData with ChangeNotifier {
  String id;
  String title;
  List<SwitchItemData> switchList = [];

  SwitchCombinationItemData(this.title, this.switchList);
}
