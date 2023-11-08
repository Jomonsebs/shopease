import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopease/models/ordermodel.dart';
import 'package:shopease/screens/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class OrderdetailsPage extends StatefulWidget {
  const OrderdetailsPage({Key? key});

  @override
  State<OrderdetailsPage> createState() => _OrderdetailsPageState();
}

class _OrderdetailsPageState extends State<OrderdetailsPage> {
  String? username;
  Future<List<OrderModel>?>? orderDetails;

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      orderDetails = fetchOrderDetails(username ?? "");
    });
    print("isLoggedIn = " + username.toString());
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<List<OrderModel>?> fetchOrderDetails(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://bootcamp.cyralearnings.com/get_orderdetails.php'),
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load order details');
      }
    } catch (e) {
      print("order details error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const drawerscreen()),
            );
          },
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<OrderModel>?>(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Failed to load order details'),
            );
          } else {
            final orderList = snapshot.data!;
            return ListView.builder(
              itemCount: orderList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final orderDetails = orderList[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 0,
                    color: const Color.fromARGB(15, 74, 20, 140),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ExpansionTile(
                      trailing: Icon(Icons.arrow_drop_down),
                      textColor: Colors.black,
                      collapsedTextColor: Colors.black,
                      iconColor: Colors.red,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                             Text(
                                      DateFormat.yMMMEd()
                                          .format(orderDetails.date),
                                      // "12-03-2023",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                
                                  SizedBox(
                                    height: 10,
                                  ),
                          Text(
                            orderDetails.paymentmethod.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            orderDetails.totalamount.toString() + " /-",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        ListView.separated(
                          itemCount: orderDetails.products.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 25),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
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
                                        padding: const EdgeInsets.only(
                                          left: 9,
                                        ),
                                        child: Image.network("http://bootcamp.cyralearnings.com/products/" + orderDetails.products[index].image,
),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Wrap(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                orderDetails.products[index]
                                                    .productname,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    orderDetails
                                                        .products[index].price
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    orderDetails.products[index]
                                                            .quantity
                                                            .toString() +
                                                        " X",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
