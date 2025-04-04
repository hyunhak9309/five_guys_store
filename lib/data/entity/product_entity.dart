import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';
part 'product_entity.g.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  factory ProductEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'price') required double price,
    @JsonKey(name: 'description') required String description,
    @JsonKey(name: 'image') required String image,
  }) = _ProductEntity;

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
        _$ProductEntityFromJson(json);
}
