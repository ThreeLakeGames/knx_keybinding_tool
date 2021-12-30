import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:provider/provider.dart';

class RockerTile extends StatefulWidget {
  final bool shouldRenderImage;
  final width;
  final height;
  final index;

  RockerTile(this.width, this.height, this.index, this.shouldRenderImage);

  @override
  _RockerTileState createState() => _RockerTileState();
}

class _RockerTileState extends State<RockerTile> {
  // TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final rockersData = Provider.of<SwitchItemData>(context).rockerData;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: !widget.shouldRenderImage
          ? BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
            )
          : null,
      child: Center(
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          initialValue: rockersData[widget.index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
          onChanged: (value) {
            rockersData[widget.index] = value;
          },
        ),
      ),
    );
  }
}
