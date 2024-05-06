import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';

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
    return Material(
      borderRadius: kBorderRadius,
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
            child: Row(
              children: [
                Container(
                  width: 250,
                ),
                Expanded(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Center(
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
