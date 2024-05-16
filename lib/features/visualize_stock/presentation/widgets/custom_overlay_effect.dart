import 'dart:ui';

import 'package:flutter/material.dart';

class CustomOverlayEffect extends StatelessWidget {
  const CustomOverlayEffect({
    super.key,
    required this.width,
    required this.hideOverlay,
    required this.child,
  });

  final double width;
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 57, 0, 40),
                    child: SizedBox(
                      width: width,
                      height: double.infinity,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
