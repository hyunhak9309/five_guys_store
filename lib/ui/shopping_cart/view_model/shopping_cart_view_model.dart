import 'package:fiveguysstore/application/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/entity/shopping_cart_entity.dart';

part 'shopping_cart_view_model.g.dart';

@riverpod
class ShoppingCartViewModel extends _$ShoppingCartViewModel {
  @override
  Future<List<ShoppingCartEntity>> build() async {
    logger.w("ShoppingCartViewModel build : ${DateTime.now()}");
    return [];
  }
}
