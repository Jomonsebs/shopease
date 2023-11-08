import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease/provider/cart.dart';
import 'package:shopease/screens/checkout_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Cart",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          if (!cart.getItems.isEmpty)
            IconButton(
              onPressed: () {
                cart.clearCart();
              },
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 56, 55, 55),
              ),
            ),
        ],
      ),
      body: cart.getItems.isEmpty
          ? Center(
              child: Text("Empty Cart"),
            )
          : ListView.builder(
              itemCount: cart.count ?? 0,
              itemBuilder: (context, index) {
                final cartProduct = cart.getItems[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(cartProduct.imagesUrl),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cartProduct.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(97, 97, 97, 1),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rs. ${cartProduct.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                cartProduct.qty == 1
                                                    ? cart.removeItem(cartProduct)
                                                    : cart.reduceByOne(
                                                        cartProduct);
                                              },
                                              icon: cartProduct.qty == 1
                                                  ? Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                    )
                                                  : Icon(
                                                      Icons.minimize_rounded,
                                                      size: 18,
                                                    ),
                                            ),
                                            Text(
                                              cartProduct.qty.toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red.shade900,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                cart.increment(cartProduct);
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total : " + cart.totalPrice.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 20,
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
           InkWell(
  onTap: () {
    if (cart.getItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          content: Text(
            "Cart is empty !!!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CheckoutPage(cart: cart.getItems); // Pass the cart data to CheckoutPage
        },
      ));
    }
  },
  child: Container(
    height: 50,
    width: MediaQuery.of(context).size.width / 2.2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.black,
    ),
    child: Center(
      child: Text(
        "Order Now",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
