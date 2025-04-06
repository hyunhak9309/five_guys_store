import 'package:fiveguysstore/ui/home/view/widget/recommand_list_card.dart';
import 'package:fiveguysstore/ui/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RecommendList extends ConsumerWidget {
  const RecommendList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '추천 상품',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 145,
          child: viewModel.when(
            data:
                (products) {
                  final thisData = List.from(products);
                  thisData.shuffle(); // 리스트를 랜덤으로 섞기
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = thisData[index];
                      return RecommandListCard(product: product);
                    },
                  );
                },
            error: (error, stack) => Center(child: Text('Error: $error')),
            loading:
                () => Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballScaleRippleMultiple,
                  ),
                ),
          ),
        ),
        const SizedBox(height: 5),
        Container(width: double.infinity, height: 2, color: Colors.grey),
        const SizedBox(height: 5),
        Container(width: double.infinity, height: 2, color: Colors.grey),
      ],
    );
  }
}
