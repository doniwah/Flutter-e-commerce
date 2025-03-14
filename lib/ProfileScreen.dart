import 'package:flutter/material.dart';

import 'BottomNavbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data untuk menu setting
    final List<Map<String, dynamic>> accountSettings = [
      {
        'icon': Icons.home_outlined,
        'title': 'My Addresses',
        'subtitle': 'Set shopping delivery address',
      },
      {
        'icon': Icons.shopping_cart_outlined,
        'title': 'My Cart',
        'subtitle': 'Add, remove products and move to checkout',
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'My Orders',
        'subtitle': 'In-progress and Completed Orders',
      },
      {
        'icon': Icons.account_balance_outlined,
        'title': 'Bank Account',
        'subtitle': 'Withdraw balance to registered bank account',
      },
      {
        'icon': Icons.confirmation_number_outlined,
        'title': 'My Coupons',
        'subtitle': 'List of all the discounted coupons',
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'subtitle': 'Set any kind of notification message',
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Account Privacy',
        'subtitle': 'Manage data usage and connected accounts',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/12345678?v=4', // Replace with your image URL
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Coding with T',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'support@codingwithT.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.edit_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Account Settings
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...accountSettings
                        .map((setting) => _buildSettingItem(setting))
                        .toList(),
                  ],
                ),
              ),

              // Divider
              const Divider(height: 1),

              // App Settings
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Add your app settings here
                    // For example, dark mode toggle, language selection, etc.
                  ],
                ),
              ),

              // Spacer for the BottomNavigationBar
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildSettingItem(Map<String, dynamic> setting) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              setting['icon'],
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  setting['subtitle'],
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
