import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final TextInputType keyboardType;
  final int maxLines;

  const ProductTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
    );
  }
}
