import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart._provider.dart';
import 'package:shop_app/provider/order.dart';

import '../widgets/cart_item.dart';

class AddCartScreen extends StatelessWidget {
//  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  kButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
                imgUrl: cart.items.values.toList()[i].imgUrl,
                id: cart.items.values.toList()[i].id,
                pid: cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class kButton extends StatefulWidget {
  const kButton({
    super.key,
    required this.cart,
  });

  final CartProvider cart;

  @override
  State<kButton> createState() => _kButtonState();
}

class _kButtonState extends State<kButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrderProvider>(context, listen: false)
                    .addOrders(widget.cart.items.values.toList(),
                        widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clearOrder();
              },
        child: _isLoading ? CircularProgressIndicator() : Text("Add to Cart"));
  }
}
