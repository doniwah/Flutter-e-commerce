import 'package:flutter/material.dart';
import 'BottomNavbar.dart';

class FeaturedBrandsScreen extends StatelessWidget {
  const FeaturedBrandsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data untuk brand
    final List<Map<String, dynamic>> brands = [
      {
        'name': 'Nike',
        'logo': 'assets/nike_logo.png', // Ganti dengan path logo Nike Anda
        'products': '265 products',
        'verified': true,
      },
      {
        'name': 'Adidas',
        'logo': 'assets/adidas_logo.png', // Ganti dengan path logo Adidas Anda
        'products': '95 products',
        'verified': true,
      },
      {
        'name': 'Kenwood',
        'logo':
            'assets/kenwood_logo.png', // Ganti dengan path logo Kenwood Anda
        'products': '36 products',
        'verified': true,
      },
      {
        'name': 'IKEA',
        'logo': 'assets/ikea_logo.png', // Ganti dengan path logo IKEA Anda
        'products': '36 products',
        'verified': true,
      },
    ];

    // Data untuk kategori
    final List<String> categories = [
      'Sports',
      'Furniture',
      'Electronics',
      'Clothes'
    ];

    // Data untuk produk Nike
    final List<Map<String, dynamic>> nikeProducts = [
      {
        'image':
            'assets/nike_green.png', // Ganti dengan path gambar sepatu Nike hijau
        'color': Colors.teal,
      },
      {
        'image':
            'assets/nike_red.png', // Ganti dengan path gambar sepatu Nike merah
        'color': Colors.red,
      },
      {
        'image':
            'assets/nike_blue.png', // Ganti dengan path gambar sepatu Nike biru
        'color': Colors.blue,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search in Store',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Brands Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Brands',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'View all',
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Brands Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          // Brand Logo
                          // Ganti dengan Image.asset jika memiliki logo
                          index == 0
                              ? Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/1200px-Logo_NIKE.svg.png',
                                  width: 40,
                                  height: 20,
                                )
                              : index == 1
                                  ? Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/1280px-Adidas_Logo.svg.png',
                                      width: 40,
                                      height: 20,
                                    )
                                  : index == 2
                                      ? Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Kenwood_Limited_logo.svg/2560px-Kenwood_Limited_logo.svg.png',
                                          width: 40,
                                          height: 20,
                                        )
                                      : Image.network(
                                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Ikea_logo.svg/2560px-Ikea_logo.svg.png',
                                          width: 40,
                                          height: 20,
                                        ),
                          const SizedBox(width: 8),
                          // Brand Name and Product Count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      brands[index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (brands[index]['verified'])
                                      Icon(
                                        Icons.verified,
                                        color: Colors.blue,
                                        size: 14,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  brands[index]['products'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
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

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == 0;
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 16 : 0,
                          right: 16,
                        ),
                        child: Column(
                          children: [
                            Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isSelected)
                              Container(
                                width: 40,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Nike Products
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    // Brand Header
                    Row(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Logo_NIKE.svg/1200px-Logo_NIKE.svg.png',
                          width: 40,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: const [
                            Text(
                              'Nike',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Product Count
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '265 products',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Product Images
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: nikeProducts.map((product) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset(
                              product['image'],
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback image if asset not found
                                return product['color'] == Colors.teal
                                    ? Image.network(
                                        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/1eeaacc0-e07c-4024-a5f7-57f2fd23e8a2/air-max-90-shoes-hnBr9m.png',
                                        width: 60,
                                        height: 60,
                                      )
                                    : product['color'] == Colors.red
                                        ? Image.network(
                                            'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/a42a5d53-2f99-4e78-a081-9d07a3f5d3f1/air-jordan-1-mid-shoes-86f1ZW.png',
                                            width: 60,
                                            height: 60,
                                          )
                                        : Image.network(
                                            'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/a3cc9b24-bc5c-4b44-9a5a-558e3d5ee570/air-jordan-1-mid-shoes-SQf7DM.png',
                                            width: 60,
                                            height: 60,
                                          );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Adidas Products
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    // Brand Header
                    Row(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/1280px-Adidas_Logo.svg.png',
                          width: 40,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: const [
                            Text(
                              'Adidas',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Product Count
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '95 products',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Spacer untuk BottomNavigationBar
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      // Anda akan menggabungkan bagian ini dengan BottomNavBar yang sudah ada
      bottomNavigationBar: const BottomNavBar(
          currentIndex: 1), // Sesuaikan dengan index yang tepat
    );
  }
}
