import 'package:fiveguysstore/data/entity/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();

  Future<void> updateProduct(List<ProductEntity> products);
}
