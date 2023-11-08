import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopease/provider/cart.dart';
import 'package:shopease/screens/cart_view.dart';
import 'package:shopease/screens/dashboard.dart';
import 'package:shopease/screens/login.dart';
import 'package:shopease/screens/order_details.dart';
import 'package:badges/badges.dart' as badges;

class drawerscreen extends StatefulWidget {
  const drawerscreen({Key? key});

  @override
  State<drawerscreen> createState() => _drawerscreenState();
}

class _drawerscreenState extends State<drawerscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ShopEase',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'ShopEase',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Replace with the code to navigate to the Home page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: badges.Badge(
                showBadge: context.read<Cart>().getItems.isNotEmpty,
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
              title: Text("Cart Page"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Replace with the code to navigate to the Cart Page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Order Details"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Replace with the code to navigate to the Order Details Page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(                    builder: (context) => OrderdetailsPage(),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("isLoggedIn", false);
                prefs.setString("username", "");

                // Replace with the code to navigate to the Login Page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Dashboard(),
    );
  }
}
