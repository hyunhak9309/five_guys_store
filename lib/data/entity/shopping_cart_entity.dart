import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_cart_entity.freezed.dart';
part 'shopping_cart_entity.g.dart';

@freezed
abstract class ShoppingCartEntity with _$ShoppingCartEntity {
  factory ShoppingCartEntity({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'num') required int num,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'product') required ProductEntity product,
  }) = _ShoppingCartEntity;

  factory ShoppingCartEntity.fromJson(Map<String, dynamic> json) =>
        _$ShoppingCartEntityFromJson(json);
}
