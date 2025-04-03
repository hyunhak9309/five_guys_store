import 'package:fiveguysstore/application/utils/logger.dart';
import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/entity/shopping_cart_entity.dart';

part 'shopping_cart_view_model.g.dart';

@riverpod
class ShoppingCartViewModel extends _$ShoppingCartViewModel {
  @override
  List<ShoppingCartEntity> build()  {
    logger.w("ShoppingCartViewModel build : ${DateTime.now()}");
    return [];
  }

  void addProduct(ProductEntity product, int num) {
    // 카트에 있는지 productId로 찾아본다.
    final cartItemIndex = state.indexWhere((element) => element.productId == product.id);
    if (cartItemIndex != -1) {
      // 있으면 수량을 증가시킨다.
      final updatedCartItem = state[cartItemIndex].copyWith(num: state[cartItemIndex].num + num, totalPrice: state[cartItemIndex].totalPrice + product.price * num);
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == cartItemIndex) updatedCartItem else state[i]
      ];
    } else {
      // 없으면 새로 추가한다.
      state = [...state, ShoppingCartEntity(productId: product.id, num: num, totalPrice: product.price * num, product: product)];
    }
  }

  // update

  // delete
}
