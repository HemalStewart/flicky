import 'package:flutter/material.dart';

class FlickyMark extends StatelessWidget {
  const FlickyMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}
