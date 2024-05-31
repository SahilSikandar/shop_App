import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shop_app/provider/model/products.dart';
import 'package:shop_app/provider/provider_controller.dart';

import 'shop_items.dart';

class GridsProduct extends StatelessWidget {
  final bool showFavrites;
  const GridsProduct({required this.showFavrites, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderController>(context);
    final prodProvider = showFavrites ? provider.favroiteItems : provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: prodProvider.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: prodProvider[index],
          child: ShopItems(
              // id: provider.items[index].id,
              // imageUrl: provider.items[index].imageUrl.toString(),
              // title: provider.items[index].title,
              ),
        );
      },
    );
  }
}
