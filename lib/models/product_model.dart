class ProductModel {
  final int id;
  final int catid;
  final String productname;
  final double price;
  final String image;
  final String description;

  ProductModel({
    required this.id,
    required this.catid,
    required this.productname,
    required this.price,
    required this.image,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      catid: json['catid'],
      productname: json['productname'],
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
    );
  }
}