import 'package:flutter/material.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';

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
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 57, 0, 40),
                  child: Container(
                    width: width,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: kSecondaryBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      boxShadow: kBoxShadowList,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomContainer(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryBackgroundColor,
                            borderRadius: kBorderRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: child,
                          ),
                        ),
                      ),
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
