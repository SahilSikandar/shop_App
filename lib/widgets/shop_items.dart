// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart._provider.dart';
import 'package:shop_app/routes/routes.dart';

import '../provider/model/products.dart';

class ShopItems extends StatefulWidget {
  // String id;
  // String imageUrl;
  // String title;
  const ShopItems(
      {
      //   required this.title,
      // required this.id,
      // required this.imageUrl,
      super.key});

  @override
  State<ShopItems> createState() => _ShopItemsState();
}

class _ShopItemsState extends State<ShopItems> {
  // void changeScreen(BuildContext ctx) {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // print("rebuild");
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.routeProductDetailScreen, arguments: product.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(product.title),
            trailing: Consumer<CartProvider>(
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    value.addItems(product.id!, product.price, product.title,
                        product.imageUrl);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('This item added to cart'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          cart.removeItem(product.id);
                        },
                      ),
                    ));
                  },
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.orange,
                );
              },
            ),
            leading: Consumer<Product>(
              builder: (context, value, child) {
                return IconButton(
                  onPressed: () {
                    product.setFavourite(auth.token, auth.userId);
                  },
                  icon: Icon(product.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border_outlined),
                  color: Colors.orange,
                );
              },
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
