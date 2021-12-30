import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/subArea/sub_area_data.dart';
import 'package:knx_keybinding_tool/provider/switch_combination_item_data.dart';
import 'package:knx_keybinding_tool/switch/new_switch.dart';
import 'package:knx_keybinding_tool/switch/switch_combination.dart';
import 'package:provider/provider.dart';

class SubAreaOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final switchCombinationDataList =
        Provider.of<SubAreaData>(context).switchCombinationList;

    return switchCombinationDataList.isEmpty
        ? Center(
            child: Text("Noch keine Schalter hinzugefügt..."),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Wrap(
                spacing: 50,
                children:
                    _buildSwitchCombinationItems(switchCombinationDataList),
              ),
            ),
          );
  }

  List<Widget> _buildSwitchCombinationItems(
      List<SwitchCombinationItemData> switchCombinationDataList) {
    List<Widget> switchCombinationList = [];
    switchCombinationDataList.forEach(
      (switchCombinationData) {
        switchCombinationList.add(
          ChangeNotifierProvider.value(
            value: switchCombinationData,
            child: SwitchCombination(),
          ),
        );
      },
    );
    return switchCombinationList;
  }

  void startAddNewSwitch(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewSwitch();
      },
    );
  }
}
