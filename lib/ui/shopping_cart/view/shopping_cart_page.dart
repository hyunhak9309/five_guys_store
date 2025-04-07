import 'package:fiveguysstore/ui/shopping_cart/view/widget/item_card.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingCartPage extends ConsumerWidget {
  const ShoppingCartPage({super.key});
  static const path = '/shopping_cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(shoppingCartViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body:
          viewModel.isEmpty
              ? const Center(child: Text('장바구니가 비었습니다.'))
              : ListView.builder(
                itemCount: viewModel.length,
                itemBuilder: (context, index) {
                  final product = viewModel[index];
                  return ItemCard(item: product);
                },
              ),
    );
  }
}
