import 'package:flutter/material.dart';

class RockerTile extends StatefulWidget {
  final width;
  final height;

  RockerTile(this.width, this.height);

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
        child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          onEditingComplete: () {
            FocusScope.of(context).nextFocus();
          },
        ),
      ),
    );
  }
}
