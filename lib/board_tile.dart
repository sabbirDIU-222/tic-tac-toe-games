// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import './tile_state.dart';

class BoardTile extends StatelessWidget {
  final double dimension;
  final VoidCallback onpressed;
  final TileState tileState;

  const BoardTile(
      {super.key,
      required this.dimension,
      required this.onpressed,
      required this.tileState});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      child: TextButton(
        onPressed: onpressed,
        child: widgetfotChildState(),
      ),
    );
  }

  Widget widgetfotChildState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;
      case TileState.CROSS:
        {
          widget = Image.asset('images/x.png');
        }
        break;
      case TileState.CIRCLE:
        {
          widget = Image.asset('images/o.png');
        }
        break;
    }

    return widget;
  }
}
