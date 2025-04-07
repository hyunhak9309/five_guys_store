import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/home/view/widget/c_image_widget.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ProductDetailsPage extends HookConsumerWidget {
  static const path = '/product_details'; // 라우트 경로 (필요시 사용)
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 수량 상태 관리 (1~99)
    final productNum = useState(1);

    // 장바구니 뷰모델
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    // 가격 포맷터
    final NumberFormat formatter = NumberFormat('#,###');
    // 수량 증가 버튼 클릭 시 수량 증가(증가일 경우 true, 감소일 경우 false 로 호출)
    // 수량 표현하는 부분은 productNum.value.toString() 로 텍스트 위젯 안에 표현
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
              actions: [TextButton(onPressed: () {
                context.pop();
                context.pop();
              }, child: const Text('확인'))],
            ),
      );
    }

    // 구매 확인 다이얼로그
    void showPurchaseDialog() {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('${product.name}을(를) ${productNum.value}개 구매하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 장바구니에 추가 viewModelFC.addProduct(product: 현재 페이지 들어올떄 받았던 productEntity, num: 갯수);
                    viewModelFC.addProduct(
                      product: product,
                      num: productNum.value,
                    );
                    Navigator.pop(context);
                    showConfirmationDialog();
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
      );
    }

    // 총 가격 계산
    final double totalPrice = product.price * productNum.value;
    final String formattedPrice = formatter.format(product.price);
    final String formattedTotal = formatter.format(totalPrice);

    return Scaffold(
      // 앱바: 뒤로가기 + 상품명
      appBar: AppBar(
        scrolledUnderElevation: 0, //
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                child: CImageWidget(image: product.image),
              ),
            ),
            const SizedBox(height: 16),

            // 상품명과 가격
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('$formattedPrice 원', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            // 상품 설명
            const Text(
              '상품 설명',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      // 하단 구매 영역
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                // 수량 조절
                IconButton(
                  onPressed: () => updateProductNum(false),
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  productNum.value.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () => updateProductNum(true),
                  icon: const Icon(Icons.add),
                ),
                const Spacer(),

                // 가격 정보
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('총 가격', style: TextStyle(fontSize: 14)),
                    Text(
                      '$formattedTotal 원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),

                // 구매 버튼
                ElevatedButton(
                  onPressed: showPurchaseDialog,
                  child: const Text('구매하기'),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
