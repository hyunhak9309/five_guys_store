import 'package:fiveguysstore/application/config/dependency.dart';
import 'package:fiveguysstore/application/utils/logger.dart';
import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<List<ProductEntity>> build() async {
    final productRepository = ref.read(productRepositoryProvider);
    final result = await productRepository.getProducts();
    logger.w(
      "HomeViewModel build : ${DateTime.now()}\n initial Products num is ${result.length}",
    );
    return result;
    // return [];
  }

  //추가
  Future<void> addProduct({required String name, required double price, required String description, required String imageUrl}) async {
    state = const AsyncValue.loading().whenData((value) => value);
    state = await AsyncValue.guard(() async {
      final product = ProductEntity(id: Uuid().v4(), name: name, price: price, description: description, image: imageUrl);
      final result = [...state.value!, product];
      final productRepository = ref.read(productRepositoryProvider);
      await productRepository.updateProduct(result);
      return result;
    });
  }

  //삭제
  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading().whenData((value) => value);
    state = await AsyncValue.guard(() async {
      final result = state.value!.where((product) => product.id != id).toList();
      final productRepository = ref.read(productRepositoryProvider);
      await productRepository.updateProduct(result);
      return result;
    });
  }
}

