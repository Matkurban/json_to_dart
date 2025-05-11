// 可拖动分割面板组件
import 'package:flutter/material.dart';

class ResizablePanels extends StatefulWidget {
  final Widget child1;
  final Widget child2;
  final double minWidth;

  const ResizablePanels({
    super.key,
    required this.child1,
    required this.child2,
    this.minWidth = 240,
  });

  @override
  State<ResizablePanels> createState() => _ResizablePanelsState();
}

class _ResizablePanelsState extends State<ResizablePanels>
    with AutomaticKeepAliveClientMixin {
  double? _leftWidth;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _leftWidth ??= constraints.maxWidth / 2;
        return Row(
          children: [
            SizedBox(width: _leftWidth, child: widget.child1),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _leftWidth = (_leftWidth! + details.delta.dx).clamp(
                    widget.minWidth,
                    constraints.maxWidth - widget.minWidth,
                  );
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: Container(
                  width: 8,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 3,
                      height: double.infinity,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: widget.child2),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
