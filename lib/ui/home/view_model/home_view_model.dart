import 'package:fiveguysstore/application/utils/logger.dart';
import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<List<ProductEntity>> build() async {
    logger.w("HomeViewModel build : ${DateTime.now()}");
    return [];
  }
}
