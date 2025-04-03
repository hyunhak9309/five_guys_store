import 'dart:convert';

import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/domain/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final products = prefs.getStringList('products') ?? [];
      return products.map((String e) => ProductEntity.fromJson(jsonDecode(e))).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addProduct(ProductEntity product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
