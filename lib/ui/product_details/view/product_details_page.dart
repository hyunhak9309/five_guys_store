import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetailsPage extends HookConsumerWidget {
  const ProductDetailsPage({super.key, required this.product});
  static const path = '/product_details';
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);
    // 카트에 추가하는 로직 부르는 법 : viewModelFC.addProduct(product: 현재 페이지 들어올떄 받았던 productEntity, num: 갯수);

    final productNum = useState(1);

    // 수량 증가 버튼 클릭 시 수량 증가(증가일 경우 true, 감소일 경우 false 로 호출)
    // 수량 표현하는 부분은 productNum.value.toString() 로 텍스트 위젯 안에 표현
    void updateProductNum(bool isPlus) {
      if (isPlus) {
        if (productNum.value < 100) {
          productNum.value++;
        }
      } else {
        if (productNum.value > 1) {
          productNum.value--;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
    );
  }
}