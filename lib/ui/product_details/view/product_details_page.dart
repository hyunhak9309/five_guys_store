import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({super.key, required this.product});
  static const path = '/product_details';
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    // 카트에 추가하는 로직 부르는 법 : viewModelFC.addProduct(product: 현재 페이지 들어올떄 받았던 productEntity, num: 갯수);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
    );
  }
}