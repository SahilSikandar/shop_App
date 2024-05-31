import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/provider_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final idData = ModalRoute.of(context)?.settings.arguments;
    final productDetail =
        Provider.of<ProviderController>(context, listen: false)
            .finfById(idData as String);

    return Scaffold(
      appBar: AppBar(
        title: Text(productDetail.title),
      ),
      body: Column(
        children: [
          Image.network(
            productDetail.imageUrl,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            productDetail.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Price: ${productDetail.price}\$",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            productDetail.description,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
