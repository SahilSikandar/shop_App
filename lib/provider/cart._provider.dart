import 'package:flutter/material.dart';
import 'package:shop_app/provider/model/cart_Item_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  Map<String, CartItemModel> get items => {..._items};
  //int _countItems = 0;
  int get countItems {
    return _items.length;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _items.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });
    return totalAmount;
  }

  void addItems(String productId, double price, String title, String imgUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItemModel(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              imgUrl: existingItem.imgUrl,
              quantity: existingItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItemModel(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              imgUrl: imgUrl,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearOrder() {
    _items = {};
    notifyListeners();
  }

  void undoItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItemModel(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              imgUrl: existingItem.imgUrl,
              quantity: existingItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
  }
}
