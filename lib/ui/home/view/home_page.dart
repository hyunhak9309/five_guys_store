import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/home/view/widget/cart_icon.dart';
import 'package:fiveguysstore/ui/home/view/widget/product_list_view.dart';
import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:fiveguysstore/ui/product_registration/view/product_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: Colors.blue, // 배경색 blue
        scrolledUnderElevation: 0, // 스크롤 시 그림자 안생기도록 설정
        actions: [const CartIcon(), const SizedBox(width: 10)],
      ),
      body: viewModel.when(
        data:
            (products) =>
                products.isEmpty
                    ? const Center(child: Text('상품이 없습니다.'))
                    : ProductListView(products: products),
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading:
            () => Center(
              child: LoadingIndicator(
                indicatorType: Indicator.ballScaleRippleMultiple,

                /// Required, The loading type of the widget
                colors: [Colors.blue],
                strokeWidth: 5,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.transparent,
              ),
            ),
      ),
      floatingActionButton: CInkWell(
        onTap: () => context.push(ProductRegistrationPage.path),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
