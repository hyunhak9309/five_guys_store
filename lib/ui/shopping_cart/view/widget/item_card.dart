import 'package:fiveguysstore/data/entity/shopping_cart_entity.dart';
import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/home/view/widget/c_image_widget.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemCard extends ConsumerWidget {
  const ItemCard({super.key, required this.item});
  final ShoppingCartEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelFC = ref.read(shoppingCartViewModelProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        spacing: 10,
        children: [
          CImageWidget(image: item.product.image),
          Expanded(
            child: Column(
              children: [
                Text(item.product.name),
                Row(
                  spacing: 10,
                  children: [
                    CInkWell(
                      onTap:
                          () => viewModelFC.updateProductNum(
                            productId: item.productId,
                            plus: false,
                          ),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.remove),
                      ),
                    ),
                    Text(item.num.toString()),
                    CInkWell(
                      onTap:
                          () => viewModelFC.updateProductNum(
                            productId: item.productId,
                            plus: true,
                          ),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
              Text(item.product.price.toString()),
              Container(),
            ],
          ),
        ],
      ),
    );
  }
}
