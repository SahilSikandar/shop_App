// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/order_item.dart';
import 'model/cart_Item_model.dart';
import 'dart:convert';

class OrderModel {
  final String id;
  final DateTime dateTime;
  final List<CartItemModel> products;
  final double amount;
  OrderModel({
    required this.id,
    required this.dateTime,
    required this.products,
    required this.amount,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final String authToken;
  final String userId;
  List<OrderModel> get orders {
    return [..._orders];
  }

  OrderProvider(this.authToken, this.userId, this._orders);
  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://sahil-4be86-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<OrderModel> _loadedOrders = [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      data.forEach((orderId, orderData) {
        _loadedOrders.add(OrderModel(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
            products: (orderData['products'] as List<dynamic>)
                .map((e) => CartItemModel(
                    id: e['id'],
                    title: e['title'],
                    price: e['price'],
                    quantity: e['quantity'],
                    imgUrl: e['imageUrl']))
                .toList()));
      });
      _orders = _loadedOrders;
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addOrders(List<CartItemModel> cart, double total) async {
    final url = Uri.parse(
        'https://sahil-4be86-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStap = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStap.toIso8601String(),
            'products': cart
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                      'imageUrl': e.imgUrl
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderModel(
              id: json.decode(response.body)['name'],
              dateTime: timeStap,
              products: cart,
              amount: total));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
