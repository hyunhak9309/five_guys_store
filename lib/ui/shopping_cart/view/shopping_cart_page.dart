import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingCartPage extends ConsumerWidget {
  const ShoppingCartPage({super.key});
  static const path = '/shopping_cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(shoppingCartViewModelProvider);
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: ListView.builder(
        itemCount: viewModel.length,
        itemBuilder: (context, index) {
          final product = viewModel[index];
          // TODO: products를 인자로 받는 상품 카드 위젯을 구현,
          // TODO: 상품 카트 위젯에서 수량 변경 버튼 클릭 시, 수량 변경 로직 호출 viewModelFC.updateProductNum(productId: product.id, plus: 증가면 true, 감소면 false)
          // TODO: 상품 카트 위젯에서 삭제 버튼 클릭 시, 삭제 로직 호출 viewModelFC.deleteProduct(productId: product.id)
        },
      ),
    );
  }
}
