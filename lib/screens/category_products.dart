import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopease/models/product_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shopease/screens/details_page.dart';

class CatproductsDetailsPage extends StatefulWidget {
  final int catid;
  final String category;
  CatproductsDetailsPage({required this.catid, required this.category});

  @override
  _CatproductsDetailsPageState createState() =>
      _CatproductsDetailsPageState();
}

class _CatproductsDetailsPageState extends State<CatproductsDetailsPage> {
  late Future<List<ProductModel>> futureCatproductsList;

  @override
  void initState() {
    super.initState();
    futureCatproductsList = fetchCatproductsList(widget.catid);
  }

  Future<List<ProductModel>> fetchCatproductsList(int catid) async {
    final response = await http.post(
      Uri.parse('http://bootcamp.cyralearnings.com/get_category_products.php'),
      body: {
        'catid': catid.toString(),
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<ProductModel> catproductsList = data
          .map((catproductsJson) => ProductModel.fromJson(catproductsJson))
          .toList();
      return catproductsList;
    } else {
      throw Exception(
          'Failed to load Catproducts details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category), // Use widget.category here
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: futureCatproductsList,
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
                            image:
                                "http://bootcamp.cyralearnings.com/products/${product.image}",
                            price: product.price.toString(),
                            description: product.description,
                          );
                        },
                      ),
                    );
                    // Handle product tap
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
                            'Product Name: ${product.productname}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Price: \$${product.price.toStringAsFixed(2)}',
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
    );
  }
}
