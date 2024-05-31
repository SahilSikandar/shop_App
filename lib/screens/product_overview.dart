import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart._provider.dart';
import 'package:shop_app/provider/provider_controller.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/grids_products.dart';

import '../routes/routes.dart';

enum ShowItem { favourites, showAll }

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  var _showFavourites = false;
  var _initState = true;
  var _isLoaded = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isLoaded = true;
    });
    if (_initState) {
      Provider.of<ProviderController>(context, listen: false)
          .fetchProducts()
          .then((_) {
        setState(() {
          _isLoaded = false;
        });
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        centerTitle: true,
        actions: [
          Consumer<CartProvider>(
            builder: (context, value, ch) =>
                Badge0(child: ch!, value: value.countItems.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.routeCartScreen);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (ShowItem value) {
              setState(() {
                if (value == ShowItem.favourites) {
                  _showFavourites = true;
                } else {
                  _showFavourites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ShowItem.favourites,
                child: Text("Show favourites"),
              ),
              const PopupMenuItem(
                value: ShowItem.showAll,
                child: Text("Show All"),
              )
            ],
          ),
        ],
      ),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : GridsProduct(
              showFavrites: _showFavourites,
            ),
      drawer: const Darwer(),
    );
  }
}
