// File: lib/screens/home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/detail_product.dart';
import '../services/database_helper.dart';
import '../widgets/BottomNavbar.dart';
import './wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;
  final int _totalCarouselSlides = 3;

  List<Product> _products = [];
  bool _isLoading = true;

  // Data kategori populer
  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.music_note, 'name': 'Music'},
    {'icon': Icons.fastfood, 'name': 'Foods'},
    {'icon': Icons.phone_android, 'name': 'Electric'},
    {'icon': Icons.local_cafe, 'name': 'Coffee'},
    {'icon': Icons.pets, 'name': 'Animals'},
    {'icon': Icons.more_horiz, 'name': 'More'},
  ];

  // List of carousel slides/banners content
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'SNEAKERS OF',
      'subtitle': 'THE WEEK',
      'color': Colors.grey[300],
    },
    {
      'title': 'NEW ARRIVALS',
      'subtitle': 'COLLECTION',
      'color': Colors.grey[400],
    },
    {
      'title': 'SPECIAL',
      'subtitle': 'OFFERS',
      'color': Colors.grey[500],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
    _loadProducts(); // Tambahkan log untuk mengetahui kapan fungsi ini dipanggil
    print("initState called, loading products...");
  }

  Future<void> _loadProducts() async {
    print("_loadProducts started");
    setState(() {
      _isLoading = true;
    });
    try {
      // Print untuk memastikan DatabaseHelper bisa diakses
      print("Accessing DatabaseHelper instance");

      // Try to get products from database first
      List<Product> dbProducts = await DatabaseHelper.instance.getProducts();
      print("Products fetched from DB: ${dbProducts.length}");

      // If no products in database, add sample products
      if (dbProducts.isEmpty) {
        print("No products found in database, adding samples");
        // Sample product data
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
        ];

        // Insert sample products into database
        for (var product in sampleProducts) {
          await DatabaseHelper.instance.insertProduct(product);
          print("Inserted product: ${product.name}");
        }

        // Get products from database again
        dbProducts = await DatabaseHelper.instance.getProducts();
        print("Fetched products after insert: ${dbProducts.length}");
      }

      setState(() {
        _products = dbProducts;
        _isLoading = false;
        print("State updated with ${_products.length} products");
      });
    } catch (e) {
      print("Error loading products: $e");
      // Lebih detail untuk debugging
      print("Stack trace: ${StackTrace.current}");

      setState(() {
        _isLoading = false;
        _products = []; // Set empty list to avoid null errors
      });

      // Tampilkan pesan error ke user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load products: $e")),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentCarouselIndex =
            (_currentCarouselIndex + 1) % _totalCarouselSlides;
      });
    });
  }

  void _changeCarouselIndex(int index) {
    setState(() {
      _currentCarouselIndex = index;
    });
    _startCarouselTimer();
  }

  // Toggle favorite status of a product
  Future<void> _toggleFavorite(int index) async {
    final product = _products[index];
    final newStatus = !product.isFavorite;

    // Update in database
    await DatabaseHelper.instance.updateFavoriteStatus(product.id, newStatus);

    // Update state
    setState(() {
      _products[index].isFavorite = newStatus;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newStatus
            ? '${product.name} added to wishlist'
            : '${product.name} removed from wishlist'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'What are you looking for?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Taimoor Sikander',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shopping_cart,
                                color: Colors.blue, size: 20),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search bar - constrained width for larger screens
                  Center(
                    child: Container(
                      width: screenWidth > 600 ? 500 : double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search in Store',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Popular Categories Text
                  const Text(
                    'Popular Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categories row - with container to prevent horizontal stretch
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _categories.map((category) {
                                      return Container(
                                        width: 70,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                category['icon'],
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              category['name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: screenWidth > 1200
                              ? 1100
                              : (screenWidth > 800 ? 750 : screenWidth),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Animated Carousel/Banner - responsive max width
                              SizedBox(
                                height: 160,
                                child: PageView.builder(
                                  controller: PageController(
                                      initialPage: _currentCarouselIndex),
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentCarouselIndex = index;
                                    });
                                    _startCarouselTimer();
                                  },
                                  itemCount: _carouselItems.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: _carouselItems[index]['color'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Banner Content
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _carouselItems[index]
                                                            ['title'],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        _carouselItems[index]
                                                            ['subtitle'],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Placeholder for product image
                                                Container(
                                                  width: 150,
                                                  color: Colors.black38,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Dots Indicator below Carousel
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _totalCarouselSlides,
                                    (index) => GestureDetector(
                                      onTap: () => _changeCarouselIndex(index),
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentCarouselIndex == index
                                              ? Colors.blue
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Popular Products
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Popular Products',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // You could navigate to a "all products" page here
                                    },
                                    child: const Text('View all'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Products Grid - with modified favorite button functionality
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: screenWidth > 800
                                      ? 4
                                      : (screenWidth > 600 ? 3 : 2),
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _products.length,
                                itemBuilder: (context, index) {
                                  final product = _products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                  product: product),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product Image
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: product.color,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(12),
                                                      topRight:
                                                          Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        _toggleFavorite(index),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        product.isFavorite
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        color:
                                                            product.isFavorite
                                                                ? Colors.red
                                                                : Colors.grey,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Product Info
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '\$${product.price}',
                                                  style: const TextStyle(
                                                    color: Colors.amber,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // If user taps on wishlist icon (index 2)
          if (index == 2) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WishlistScreen()));
          }
        },
      ),
    );
  }
}
