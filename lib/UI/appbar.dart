import 'dart:math';

import 'package:flutter/material.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {

  final int completedCount;
  final VoidCallback onEyePressed;
  var eyeIcon = Icons.visibility;

  MySliverAppBar ({
    required this.completedCount,
    required this.onEyePressed,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shift = min(1, shrinkOffset / (164 - 80));
    return StackBar(completedCount: completedCount, onEyePressed: onEyePressed, shift: shift);
  }

  @override
  double get maxExtent => 164;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class StackBar extends StatefulWidget {
  final int completedCount;
  final VoidCallback onEyePressed;
  final double shift;
  const StackBar ({super.key,
    required this.completedCount,
    required this.onEyePressed,
    required this.shift,
  });

  @override
  State<StackBar> createState() => _StackBarState();
}

class _StackBarState extends State<StackBar> {

  var eyeIcon = Icons.visibility;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        Material(
          shadowColor: Colors.black,
          elevation: 4.0 * widget.shift,
          child: Container(
            color: const Color(0xFFF7F6F2),
            width: MediaQuery.of(context).size.width,
            height: 164,
          ),
        ),
        Positioned(
          left: 60 - 44 * widget.shift,
          top: 82 - 46 * widget.shift,
          child: Text(
            "Мои дела",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 40 - 12 * widget.shift,
              height: (47 - 6 * widget.shift) / (40 - 12 * widget.shift),
            ),
          ),
        ),
        Positioned(
          left: 60 - 44 * widget.shift,
          top: 130 - 34 * widget.shift,
          child: Opacity(
            opacity: 1 - widget.shift < 1 ? 0 : 1,
            child: Text(
              'Выполнено — ${widget.completedCount} дел',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0x4C000000),
              ),
            ),
          ),
        ),
        Positioned(
          right: 24 - 6 * widget.shift,
          top: 114 - 77 * widget.shift,
          child: IconButton(
            icon: Icon(
              eyeIcon,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                if (eyeIcon == Icons.visibility) {
                  eyeIcon = Icons.visibility_off;
                } else {
                  eyeIcon = Icons.visibility;
                }
              });
              widget.onEyePressed();
            },
          ),
        ),
      ],
    );
  }

}



