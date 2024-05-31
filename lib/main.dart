import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart._provider.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/provider_controller.dart';
import 'package:shop_app/routes/routes.dart';
import 'package:shop_app/screens/add_cart.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import 'package:shop_app/screens/orders_Screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview.dart';
import 'package:shop_app/screens/splash.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProviderController>(
            update: (_, auth, previousProducts) => ProviderController(
                auth.token.toString(),
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: (_) => ProviderController('', "", []),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: (_) => OrderProvider('', '', []),
            update: (_, auth, previousOrders) => OrderProvider(
                auth.token.toString(),
                auth.userId,
                previousOrders == null ? [] : previousOrders.orders),
          ),
          ChangeNotifierProvider(
            create: (context) => CartProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: auth.isAuth
                ? const ProductView()
                : FutureBuilder(
                    future: auth.autoSignIn(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const Splash()
                            : AuthScreen()),
            routes: {
              Routes.routeProductViewScreen: (_) => const ProductView(),
              Routes.routeProductDetailScreen: (_) =>
                  const ProductDetailScreen(),
              Routes.routeCartScreen: (_) => AddCartScreen(),
              Routes.routeOrderScreen: (_) => const OrderScreen(),
              Routes.routeUserProductScreen: (_) => UserProductsScreen(),
              Routes.routeEditScreen: (_) => EditProductScreen()
            },
          ),
        ));
  }
}
