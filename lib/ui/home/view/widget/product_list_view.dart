import 'dart:convert';
import 'dart:io';
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      product.image.startsWith(
                            'http',
                          ) // http로 시작하면 Image.network() 사용
                          ? Image.network(
                            product.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : product.image.startsWith('file://') ||
                              product.image.startsWith(
                                '/',
                              ) // file 또는 /로 시작하면 Image.file() 사용. 플랫폼별 구분하려다가 코드가 길어지는 것 같아 이걸로 대체함.
                          ? Image.file(
                            // File(
                            // Platform.isIOS
                            // ? Uri.parse(
                            // product.image,
                            // ).path.replaceFirst('file://', '')
                            // : Uri.parse(
                            // product.image,
                            // ).path,
                            // ),
                            File(Uri.parse(product.image).toFilePath()),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                          : Image.memory(
                            // 그 외는 Image.memory() 사용 (base64)
                            base64Decode(product.image.split(',').last),
                            // 이미지 파일이 base64(문자열)로 되어있어, 이를 디코딩함. convert 임포팅
                            // data:image/jpeg;base64, 를 잘라내기 위해 split 사용
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                ),
                SizedBox(width: 16),
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
