import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './sub_area_data.dart';
import '../provider/switch_combination_item_data.dart';
import '/switch/new_switch.dart';
import '/switch/switch_combination.dart';

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
