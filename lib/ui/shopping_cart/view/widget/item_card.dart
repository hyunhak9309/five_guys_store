import 'package:fiveguysstore/data/entity/shopping_cart_entity.dart';
import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/home/view/widget/c_image_widget.dart';
import 'package:fiveguysstore/ui/product_details/view/product_details_page.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ItemCard extends ConsumerWidget {
  const ItemCard({super.key, required this.item});
  final ShoppingCartEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        spacing: 10,
        children: [
          CInkWell(
            onTap: () => context.push(ProductDetailsPage.path, extra: item.product),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CImageWidget(image: item.product.image),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      CInkWell(
                        onTap:
                            () => viewModelFC.updateProductNum(
                              productId: item.productId,
                              plus: false,
                            ),
                        child: Container(
                               decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.remove, color: Colors.black),
                        ),
                      ),
                      Text(item.num.toString()),
                      CInkWell(
                        onTap:
                            () => viewModelFC.updateProductNum(
                              productId: item.productId,
                              plus: true,
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              CInkWell(
                onTap:
                    () => viewModelFC.deleteProduct(productId: item.productId),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.cancel),
                ),
              ),

              Text("총 ${NumberFormat('#,###').format((item.product.price * item.num).toInt())}원"),
            ],
          ),
        ],
      ),
    );
  }
}
