import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/model/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProviderController with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String? authToken;
  String? userId;
  ProviderController(this.authToken, this.userId, this._items);
  List<Product> get items => [..._items];
  Product finfById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favroiteItems {
    return _items.where((element) => element.isLiked!).toList();
  }

  Future<void> fetchProducts([bool userByFilter = false]) async {
    final filter = userByFilter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://sahil-4be86-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filter';
    //const favUrl = 'https://sahil-4be86-default-rtdb.firebaseio.com/favProducts.json';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      final favUrl =
          'https://sahil-4be86-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final responseFav = await http.get(Uri.parse(favUrl));
      final responseData = json.decode(responseFav.body);
      // print(responseData);
      //print(data);
      List<Product> _loadedData = [];
      data.forEach((prodId, prodData) {
        //final isLiked = prodData['isLiked'] as bool!
        final isLiked =
            responseData == null ? false : responseData[prodId] ?? false;
        _loadedData.add(Product(
          isLiked: isLiked is bool ? isLiked : false,
          id: prodId,
          description: prodData['description'] as String? ?? '',
          title: prodData['title'] as String? ?? '',
          price: prodData['price'] as double? ?? 0.0,
          imageUrl: prodData['imageUrl'] as String? ?? '',
        ));
      });
      _items = _loadedData;
      notifyListeners();
    } catch (error) {
      throw (error.toString());
    }
  }

  Future<void> addProducts(Product product) async {
    final url = Uri.parse(
        'https://sahil-4be86-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            //'isLiked': product.isLiked
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'] as String,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        //isLiked: product.isLiked
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://sahil-4be86-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://sahil-4be86-default-rtdb.firebaseio.com/products/$id?auth=$authToken');
    final existingProductId = _items.indexWhere((prod) => prod.id == id);
    var existingprod = _items[existingProductId];
    _items.removeAt(existingProductId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductId, existingprod);
      notifyListeners();
      throw const HttpException("Couldn't Delete the product ");
    }
    existingprod = null!;
  }
}
