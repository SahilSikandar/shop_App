import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/routes/routes.dart';

class Darwer extends StatelessWidget {
  const Darwer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Sahil"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Orders"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(Routes.routeOrderScreen),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Product"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(Routes.routeUserProductScreen),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Log Out"),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
