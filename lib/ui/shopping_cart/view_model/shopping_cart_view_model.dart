import 'package:fiveguysstore/application/utils/logger.dart';
import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/entity/shopping_cart_entity.dart';

part 'shopping_cart_view_model.g.dart';

final shoppingCartViewModelProvider =
    StateNotifierProvider<ShoppingCartViewModel, List<CartItem>>((ref) {
      return ShoppingCartViewModel();
    });

class CartItem {
  final ProductEntity product;
  final int num;

  CartItem({required this.product, required this.num});

  CartItem copyWith({ProductEntity? product, int? num}) {
    return CartItem(product: product ?? this.product, num: num ?? this.num);
  }
}

class ShoppingCartViewModel extends StateNotifier<List<CartItem>> {
  ShoppingCartViewModel() : super([]);

  @override
  List<ShoppingCartEntity> build() {
    logger.w("ShoppingCartViewModel build : ${DateTime.now()}");
    return [];
  }

  void addProduct({required ProductEntity product, required int num}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // 이미 장바구니에 있는 상품이면 수량만 증가
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex].copyWith(num: state[existingIndex].num + num),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // 새로운 상품이면 추가
      state = [...state, CartItem(product: product, num: num)];
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateProductNum(String productId, int num) {
    state =
        state.map((item) {
          if (item.product.id == productId) {
            return item.copyWith(num: num);
          }
          return item;
        }).toList();
  }

  void clearCart() {
    state = [];
  }

  int get totalPrice {
    return state.fold(0, (sum, item) => sum + (item.product.price * item.num));
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.num);
  }
}
