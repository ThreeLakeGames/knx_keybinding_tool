import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/main_area_data.dart';
import '/switch/rocker_tile.dart';
import '/provider/switch_item_data.dart';

class SwitchItem extends StatefulWidget {
  @override
  _SwitchItemState createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  FocusScopeNode switchFocusNode;

  @override
  void initState() {
    super.initState();

    switchFocusNode = FocusScopeNode();
  }

  @override
  void dispose() {
    switchFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switchData = Provider.of<SwitchItemData>(context);
    bool shouldRenderImage =
        Provider.of<MainAreaData>(context, listen: false).shouldRenderImages;

    return Container(
      width: 204,
      height: 204,
      decoration: shouldRenderImage
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(switchData.imageUrl),
              ),
              boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(3.0, 3.0), //(x,y)
                    blurRadius: 10.0,
                    // spreadRadius: 10.0
                  ),
                ])
          : BoxDecoration(
              color: Color.fromRGBO(200, 200, 200, 1),
              borderRadius: BorderRadius.all(Radius.circular(6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(3.0, 3.0), //(x,y)
                  blurRadius: 10.0,
                  // spreadRadius: 10.0
                )
              ],
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
      child: _buildSpecificSwitch(switchData, shouldRenderImage),
    );
  }

  Widget _buildSpecificSwitch(
      SwitchItemData switchData, bool shouldRenderImage) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List<RockerTile>.generate(
        switchData.totalRockerSize,
        (index) => RockerTile(200 / switchData.rockerDimension.x,
            200 / switchData.rockerDimension.y, index, shouldRenderImage),
      ),
    );
  }
}
