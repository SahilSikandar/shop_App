import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text(
                "404",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Consumer<OrderProvider>(
              builder: (context, orderData, child) {
                return ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) {
                    return OrderItem(orderModel: orderData.orders[index]);
                  },
                );
              },
            );
          }
        },
      ),
      drawer: Darwer(),
    );
  }
}
