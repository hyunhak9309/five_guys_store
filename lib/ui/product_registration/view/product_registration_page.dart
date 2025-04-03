import 'package:flutter/material.dart';

class ProductRegistrationPage extends StatelessWidget {
  const ProductRegistrationPage({super.key});
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
