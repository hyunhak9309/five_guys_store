
import 'package:fiveguysstore/data/%20repository_impl/product_repository_impl.dart';
import 'package:fiveguysstore/domain/repository/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependency.g.dart';

@riverpod
ProductRepository productRepository(ref) =>
    ProductRepositoryImpl();

