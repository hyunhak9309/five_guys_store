import 'package:fiveguysstore/data/entity/product_entity.dart';
import 'package:fiveguysstore/ui/home/view/home_page.dart';
import 'package:fiveguysstore/ui/product_details/view/product_details_page.dart';
import 'package:fiveguysstore/ui/product_registration/view/product_registration_page.dart';
import 'package:fiveguysstore/ui/shopping_cart/view/shopping_cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class CustomRouter {
  CustomRouter._();
  static final CustomRouter _instance = CustomRouter._();
  factory CustomRouter() => _instance;

  GoRouter createRouter() {
    return GoRouter(
      initialLocation: HomePage.path,
      routes: [
        GoRoute(
          path: HomePage.path,
          pageBuilder:
              (context, state) => const CupertinoPage(child: HomePage()),
        ),
        GoRoute(
          path: ProductRegistrationPage.path,
          pageBuilder:
              (context, state) =>
                  const CupertinoPage(child: ProductRegistrationPage()),
        ),
        GoRoute(
          path: ShoppingCartPage.path,
          pageBuilder:
              (context, state) =>
                  const CupertinoPage(child: ShoppingCartPage()),
        ),
        GoRoute(
          path: ProductDetailsPage.path,
          pageBuilder:
              (context, state) => CupertinoPage(
                child: ProductDetailsPage(
                  product: state.extra as ProductEntity,
                ),
              ),
        ),
      ],
    );
  }
}
