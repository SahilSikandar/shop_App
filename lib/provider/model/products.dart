//import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  String id;
  String title;
  final double price;
  String description;
  String imageUrl;
  bool isLiked;

  Product(
      {required this.id,
      required this.description,
      this.isLiked = false,
      required this.title,
      required this.price,
      required this.imageUrl});

  void fav(bool? newValue) {
    isLiked = newValue!;
    notifyListeners();
  }

  void setFavourite(String token, String userId) async {
    final oldStatus = isLiked;
    isLiked = !isLiked;
    notifyListeners();
    final url =
        'https://sahil-4be86-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isLiked));
      if (response.statusCode >= 400) {
        fav(oldStatus);
      }
    } catch (e) {
      fav(oldStatus);
    }
    notifyListeners();
  }
}
