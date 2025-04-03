import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/product_details/view/product_details_page.dart';

class ProductListView extends StatelessWidget {
  final List<ProductEntity> products;
  const ProductListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: MemoryImage(
                        base64Decode(product.image.split(',').last),
                        // 이미지 파일이 base64(문자열)로 되어있어, 이를 디코딩함. convert 임포팅.
                        // data:image/jpeg;base64,를 잘라내기 위해 split 사용
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  product.price == 0
                      ? '무료배송' // 가격이 0원이라면 무료배송.
                      : '${NumberFormat('#,###').format(product.price)} 원', //천단위마다 , 쓰기 위해 intl 패키지 설치 및 수정
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
