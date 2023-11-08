import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopease/models/category_model.dart';
import 'package:shopease/models/product_model.dart';
import 'package:shopease/screens/category_products.dart';
import 'package:shopease/screens/details_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<CategoryModel>> futureCategories;
  late Future<List<ProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    futureProducts = fetchProducts();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://bootcamp.cyralearnings.com/getcategories.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<CategoryModel> categories = data
          .map((categoryModelJson) => CategoryModel.fromJson(categoryModelJson))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('http://bootcamp.cyralearnings.com/view_offerproducts.php'),
    );

    if (response.statusCode == 200) {
      final Iterable list = jsonDecode(response.body);
      final List<ProductModel> productsList = List<ProductModel>.from(
        list.map((model) => ProductModel.fromJson(model)),
      );
      return productsList;
    } else {
      throw Exception('Failed to load Products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 100,
            child: FutureBuilder<List<CategoryModel>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No categories available.'));
                } else {
                  List<CategoryModel> categories = snapshot.data!;

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category) {
                      return Container(
                        margin: EdgeInsets.all(14),
                        child: Card(
                          elevation: 5,
                          color: const Color.fromARGB(255, 127, 146, 155),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CatproductsDetailsPage(
                                      catid: category.id, category: category.category,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                '${category.category}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Most Searched Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  List<ProductModel> products = snapshot.data!;

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    itemCount: products.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ProductModel product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DetailsPage(
                                  id: product.id,
                                  name: product.productname,
                                  image: "http://bootcamp.cyralearnings.com/products/${product.image}",
                                  price: product.price.toString(),
                                  description: product.description,
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      "http://bootcamp.cyralearnings.com/products/${product.image}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '${product.productname}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}