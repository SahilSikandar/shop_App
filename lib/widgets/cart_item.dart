// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart._provider.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final String pid;
  final String imgUrl;
  final int quantity;
  final double price;
  const CartItem(
      {Key? key,
      required this.title,
      required this.pid,
      required this.id,
      required this.quantity,
      required this.price,
      required this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content:
                  const Text("Do you want to remove the item from the cart?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes")),
              ],
            );
          },
        );
      },
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8),
      ),
      onDismissed: (id) {
        Provider.of<CartProvider>(context, listen: false).removeItem(pid);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Image(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Total \$${price * quantity}"),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
