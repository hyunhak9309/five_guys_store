import 'dart:convert';

import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/home/view/widget/cart_icon.dart';
import 'package:fiveguysstore/ui/home/view/widget/product_list_view.dart';
import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:fiveguysstore/ui/product_details/view/product_details_page.dart';
import 'package:fiveguysstore/ui/product_registration/view/product_registration_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
        backgroundColor: Colors.blue, // 배경색 blue
        scrolledUnderElevation: 0, // 스크롤 시 그림자 안생기도록 설정
        actions: [const CartIcon(), const SizedBox(width: 10)],
      ),
      body: viewModel.when(
        data: (products) {
          // TODO: products를 인자로 받는 상품 카드 위젯을 구현,
          // TODO: 상품 카트 위젯 클릭 시, 상품 상세 페이지로 이동(인자 라우팅 이동간에 전달 필요, 필요하면 질문주세요!)

          if (products.isEmpty) {
            return const Center(child: Text('상품이 없습니다.'));
          } // 상품이 없을 경우, 화면 구현.

          return ProductListView(products: products);
        },

        error: (error, stack) {
          return Center(child: Text('Error: $error'));
        },
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
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
