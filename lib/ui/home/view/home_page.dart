import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:fiveguysstore/ui/product_registration/view/product_registration_page.dart';
import 'package:fiveguysstore/ui/shopping_cart/view/shopping_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        actions: [
          CInkWell(
            onTap: () => context.push(ShoppingCartPage.path),
            child: const Icon(Icons.shopping_cart),
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: CInkWell(
        onTap: () => context.push(ProductRegistrationPage.path),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}