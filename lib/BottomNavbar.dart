import 'package:flutter/material.dart';

import 'FeaturedBrandsScreen.dart';
// Import halaman-halaman yang akan dituju
import 'HomeScreen.dart'; // Sesuaikan dengan nama file Anda
// import 'wishlist_screen.dart'; // Sesuaikan dengan nama file Anda
import 'ProfileScreen.dart'; // Sesuaikan dengan nama file Anda

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index != currentIndex) {
            switch (index) {
              case 0:
                // Navigasi ke Home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
              case 1:
                // Navigasi ke Store
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FeaturedBrandsScreen()),
                );
                break;
              case 2:
                // Navigasi ke Wishlist
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => WishlistScreen()),
                // );
                break;
              case 3:
                // Navigasi ke Profile
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }
}
