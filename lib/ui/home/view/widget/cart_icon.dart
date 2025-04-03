import 'package:fiveguysstore/ui/core/view/c_inkwell.dart';
import 'package:fiveguysstore/ui/shopping_cart/view/shopping_cart_page.dart';
import 'package:fiveguysstore/ui/shopping_cart/view_model/shopping_cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartIcon extends ConsumerWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(shoppingCartViewModelProvider);
    return CInkWell(
      onTap: () => context.push(ShoppingCartPage.path),
      child: Stack(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          viewModel.when(
            data: (data)=>   Positioned(
              top : 5,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  data.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            error: (error, stack) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
          ],
      ),
    );
  }
}
