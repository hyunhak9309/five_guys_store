import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ProductDetailsPage extends HookConsumerWidget {
  static const path = '/product_details';
  final ProductEntity product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 수량 상태 관리 (1~99)
    final productNum = useState(1);

    // 장바구니 뷰모델
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    // 가격 포맷터
    final formatter = NumberFormat('#,###');

    // 수량 증감 함수
    void updateProductNum(bool isPlus) {
      if (isPlus) {
        if (productNum.value < 99) {
          productNum.value++;
        }
      } else {
        if (productNum.value > 1) {
          productNum.value--;
        }
      }
    }

    // 구매 완료 다이얼로그
    void showConfirmationDialog() {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('구매 완료'),
              content: Text('${product.name}을(를) ${productNum.value}개 구매했습니다.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }

    return Scaffold(
      // 앱바: 뒤로가기 + 상품명
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // 본문
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품 이미지
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 상품 가격
            Text(
              '${formatter.format(product.price)}원',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 상품 설명
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),

      // 하단 네비게이션 바 (수량 조절 + 구매/장바구니 버튼)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // 수량 조절
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => updateProductNum(false),
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    productNum.value.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => updateProductNum(true),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 구매/장바구니 버튼
            Expanded(
              child: Row(
                children: [
                  // 장바구니 담기 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        viewModelFC.addProduct(
                          product: product,
                          num: productNum.value,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('장바구니에 추가되었습니다.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('장바구니'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 구매하기 버튼
                  Expanded(
                    child: ElevatedButton(
                      onPressed: showConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('구매하기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
