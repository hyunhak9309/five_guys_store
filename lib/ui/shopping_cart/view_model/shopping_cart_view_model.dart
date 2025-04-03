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

  void addProduct({required ProductEntity product, required int num}) {
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
  void updateProductNum({required String productId, required bool plus}) {
    
    final cartItemIndex = state.indexWhere((element) => element.productId == productId);

    if (cartItemIndex != -1) {
      final currentItem = state[cartItemIndex];
      final updatedNum = plus ? currentItem.num + 1 : currentItem.num - 1;

      if (updatedNum > 0) {
        final updatedCartItem = currentItem.copyWith(num: updatedNum, totalPrice: currentItem.totalPrice + (plus ? currentItem.product.price : -currentItem.product.price));
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == cartItemIndex) updatedCartItem else state[i]
        ];
      }
    }
  }

  // delete
  void deleteProduct({required String productId}) {
    state = state.where((element) => element.productId != productId).toList();
  }
}
