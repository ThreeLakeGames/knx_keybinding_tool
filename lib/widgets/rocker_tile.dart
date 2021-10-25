import 'package:flutter/material.dart';
import 'package:knx_keybinding_tool/provider/switch_item_data.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class RockerTile extends StatefulWidget {
  final width;
  final height;
  final index;

  RockerTile(this.width, this.height, this.index);

  @override
  _RockerTileState createState() => _RockerTileState();
}

class _RockerTileState extends State<RockerTile> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final rockersData = Provider.of<SwitchItemData>(context).rockerData;
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: Center(
        child: TextFormField(
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
