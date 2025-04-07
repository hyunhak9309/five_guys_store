import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';
part 'product_entity.g.dart';

class ProductEntity {
  final String id;
  final String name;
  final int price;
  final String description;
  final String image;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  // JSON 역직렬화
  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }

  // 복사본 생성 (불변성 유지)
  ProductEntity copyWith({
    String? id,
    String? name,
    int? price,
    String? description,
    String? image,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
