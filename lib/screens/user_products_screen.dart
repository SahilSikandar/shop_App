import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/provider_controller.dart';
import 'package:shop_app/routes/routes.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _pullRefresh(BuildContext context) async {
    await Provider.of<ProviderController>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.routeEditScreen);
            },
          ),
        ],
      ),
      drawer: const Darwer(),
      body: FutureBuilder(
        future: _pullRefresh(context),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data: ${snapshot.error}'),
            );
          } else {
            final productsData = Provider.of<ProviderController>(context);
            if (productsData.items.isEmpty) {
              return Center(
                child: Text('No products found. Please add some.'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _pullRefresh(context),
                child: Consumer<ProviderController>(
                  builder: (context, productsData, child) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (_, i) => Column(
                        children: [
                          UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
