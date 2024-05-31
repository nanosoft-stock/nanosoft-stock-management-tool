import 'package:flutter/material.dart';

class CustomOverlayEffect extends StatelessWidget {
  const CustomOverlayEffect({
    super.key,
    required this.hideOverlay,
    required this.child,
  });

  final Function() hideOverlay;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              hideOverlay();
            },
            behavior: HitTestBehavior.opaque,
          ),
          Positioned.fill(
            child: ClipRect(
              child: Center(
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
