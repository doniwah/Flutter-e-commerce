import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('db_cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      print("Database path: $path");

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) {
          print("Database opened successfully");
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    print("Creating database tables...");
    try {
      await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          price TEXT NOT NULL,
          color INTEGER NOT NULL,
          isFavorite INTEGER NOT NULL
        )
      ''');
      print("Table 'products' created successfully");
    } catch (e) {
      print("Error creating tables: $e");
      rethrow;
    }
  }

  // Debug method to check database contents
  Future<void> debugDatabase() async {
    try {
      final db = await database;
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      print("Tables in DB: $tables");

      if (tables.any((table) => table['name'] == 'products')) {
        final products = await db.rawQuery("SELECT * FROM products");
        print("All products in DB: $products");
      } else {
        print("Products table not found!");
      }
    } catch (e) {
      print("Debug DB error: $e");
    }
  }

  // Insert product into database
  Future<int> insertProduct(Product product) async {
    try {
      final db = await instance.database;
      final productMap = product.toMap();
      print("Inserting product: $productMap");

      final id = await db.insert('products', productMap,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("Product inserted with id: $id");
      return id;
    } catch (e) {
      print("Error inserting product: $e");
      rethrow;
    }
  }

  // Insert sample products if database is empty
  Future<void> insertSampleProductsIfEmpty() async {
    try {
      final products = await getProducts();
      if (products.isEmpty) {
        print("Database is empty, inserting sample products");
        final sampleProducts = [
          Product(
            id: 1,
            name: 'Sneakers Green',
            price: '85.00',
            color: Colors.teal,
            isFavorite: false,
          ),
          Product(
            id: 2,
            name: 'Blue T-Shirt',
            price: '35.00',
            color: Colors.blue,
            isFavorite: false,
          ),
          Product(
            id: 3,
            name: 'Red Hoodie',
            price: '55.00',
            color: Colors.red,
            isFavorite: false,
          ),
        ];

        for (var product in sampleProducts) {
          await insertProduct(product);
        }
        print("Sample products inserted successfully");
      }
    } catch (e) {
      print("Error inserting sample products: $e");
    }
  }

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final db = await instance.database;
      print("Fetching products from database");
      final maps = await db.query('products');
      print("Products query result: $maps");

      if (maps.isEmpty) {
        print("No products found in database");
        return [];
      }

      return List.generate(maps.length, (i) {
        try {
          final product = Product.fromMap(maps[i]);
          print(
              "Product loaded: id=${product.id}, name=${product.name}, color=${product.color}, isFavorite=${product.isFavorite}");
          return product;
        } catch (e) {
          print("Error converting map to product: ${maps[i]}");
          print("Error details: $e");
          rethrow;
        }
      });
    } catch (e) {
      print("Error getting products: $e");
      return []; // Return empty list instead of throwing
    }
  }

  // Get all favorites (wishlist items)
  Future<List<Product>> getFavorites() async {
    try {
      final db = await instance.database;
      print("Fetching favorite products");
      final maps = await db.query(
        'products',
        where: 'isFavorite = ?',
        whereArgs: [1],
      );

      print("Favorite products found: ${maps.length}");

      return List.generate(maps.length, (i) {
        try {
          return Product.fromMap(maps[i]);
        } catch (e) {
          print("Error converting map to favorite product: ${maps[i]}");
          print("Error details: $e");
          rethrow;
        }
      });
    } catch (e) {
      print("Error getting favorite products: $e");
      return [];
    }
  }

  // Update product favorite status
  Future<int> updateFavoriteStatus(int id, bool isFavorite) async {
    try {
      final db = await instance.database;
      print(
          "Updating favorite status for product id=$id to ${isFavorite ? 'favorite' : 'not favorite'}");

      final result = await db.update(
        'products',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

      print("Updated rows: $result");
      return result;
    } catch (e) {
      print("Error updating favorite status: $e");
      rethrow;
    }
  }

  // Delete product
  Future<int> deleteProduct(int id) async {
    try {
      final db = await instance.database;
      print("Deleting product with id=$id");

      final result = await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );

      print("Deleted rows: $result");
      return result;
    } catch (e) {
      print("Error deleting product: $e");
      rethrow;
    }
  }

  // Clear all products
  Future<int> clearProducts() async {
    try {
      final db = await instance.database;
      print("Clearing all products");

      final result = await db.delete('products');
      print("Cleared rows: $result");
      return result;
    } catch (e) {
      print("Error clearing products: $e");
      rethrow;
    }
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
    print("Database closed");
  }
}
