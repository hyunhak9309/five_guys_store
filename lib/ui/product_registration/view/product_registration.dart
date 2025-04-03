import 'package:flutter/material.dart';

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});
  static const path = '/product_registration';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Registration'),
      ),
    );
  }
}
