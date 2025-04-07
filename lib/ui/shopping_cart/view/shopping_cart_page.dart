import 'package:fiveguysstore/ui/shopping_cart/view/widget/item_card.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingCartPage extends ConsumerWidget {
  const ShoppingCartPage({super.key});
  static const path = '/shopping_cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(shoppingCartViewModelProvider);
    return Scaffold(
      appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('장바구니', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // 배경색 blue
        scrolledUnderElevation: 0,
      ),
      body: viewModel.isEmpty
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
