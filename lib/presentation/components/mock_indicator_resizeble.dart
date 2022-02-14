import 'package:flutter/material.dart';

class MockIndicatorResizeble extends StatefulWidget {
  final Function? onDrag;
  final Function? isPressed;
  final Function? onPanEnd;
  final Widget? iconWidget;
  final Widget? dragWidget;
  final Widget? deleteWidget;
  final double? sizeIndicator;

  const MockIndicatorResizeble({
    Key? key,
    this.onDrag,
    this.isPressed,
    this.onPanEnd,
    this.iconWidget,
    this.dragWidget,
    this.deleteWidget,
    this.sizeIndicator,
  }) : super(key: key);

  @override
  _MockIndicatorResizebleState createState() => _MockIndicatorResizebleState();
}

class _MockIndicatorResizebleState extends State<MockIndicatorResizeble> {
  double? initX;
  double? initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag!(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      onPanDown: (details) {
        if (widget.isPressed != null) {
          widget.isPressed!(true);
        }
      },
      onPanCancel: () {
        if (widget.isPressed != null) {
          widget.isPressed!(false);
        }
      },
      onPanEnd: (details) {
        if (widget.isPressed != null) {
          widget.isPressed!(false);
        }
        if (widget.onPanEnd != null) {
          widget.onPanEnd!(details);
        }
      },
      onTapUp: (details) {
        if (widget.isPressed != null) {
          widget.isPressed!(false);
        }
      },
      child: (widget.iconWidget != null)
          ? widget.iconWidget
          : Container(
              width: widget.sizeIndicator,
              height: widget.sizeIndicator,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
    );
  }
}
