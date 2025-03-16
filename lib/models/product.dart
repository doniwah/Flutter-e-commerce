import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String price;
  final Color color;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.isFavorite,
  });

  // Convert Product object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'color': color.value, // Save color as an integer value
      'isFavorite': isFavorite ? 1 : 0, // Convert bool to int (1/0)
    };
  }

  // Create a Product object from a database map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as String,
      color: Color(map['color'] as int), // Convert int back to Color
      isFavorite: map['isFavorite'] == 1, // Convert int (1/0) back to bool
    );
  }

  // Create a copy of a Product with updated properties
  Product copyWith({
    int? id,
    String? name,
    String? price,
    Color? color,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, color: $color, isFavorite: $isFavorite}';
  }
}
