import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    super.key,
    required this.field,
    required this.onPressed,
  });

  final String field;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Builder(
        builder: (BuildContext context) {
          return const Icon(Icons.filter_alt_outlined);
        },
      ),
    );
  }
}
