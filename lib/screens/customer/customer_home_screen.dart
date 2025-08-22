import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_theme.dart';
import '../../providers/simple_auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../utils/localization.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/customer_order_status.dart';
import '../../providers/categories_provider.dart';
import 'shop_listings_screen.dart';
import 'orders_list_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../../providers/notification_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(simpleAuthProvider);
    final isUrdu = ref.watch(isUrduProvider);
    final localizations = AppLocalizations.of(context);
    final user = authState.user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(user, isUrdu),
              
              // Customer Order Status
              const CustomerOrderStatus(),
              
              // Search Bar
              _buildSearchBar(),
              
              // Categories
              _buildCategories(),
              
              // Featured Shops
              Expanded(
                child: _buildFeaturedShops(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to cart
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildHeader(UserModel? user, bool isUrdu) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              user?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Welcome Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUrdu ? 'خوش آمدید' : 'Welcome back!',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  user?.name ?? 'User',
                  style: AppTheme.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Location & Notifications
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersListScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                tooltip: 'My Orders',
              ),
              IconButton(
                onPressed: () {
                  // Show location selector
                },
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final unreadCount = ref.watch(unreadCountProvider);
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search shops, food, groceries...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildCategories() {
    final categoriesAsync = ref.watch(categoriesProvider);
    
    if (categoriesAsync.isLoading) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (categoriesAsync.error != null) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            'Error loading categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final categories = categoriesAsync.categories;
    
    if (categories.isEmpty) {
      return Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            'No categories available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => _navigateToCategory(category.name),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      category.icon,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ).animate(delay: (index * 100).ms)
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.3, end: 0);
        },
      ),
    );
  }

  Widget _buildFeaturedShops() {
    final shops = [
      {
        'name': 'Bismillah Restaurant',
        'image': 'assets/images/restaurant1.jpg',
        'rating': 4.5,
        'deliveryTime': '20-30 min',
        'category': 'Pakistani Food',
        'distance': '1.2 km',
      },
      {
        'name': 'Fresh Mart Grocery',
        'image': 'assets/images/grocery1.jpg',
        'rating': 4.3,
        'deliveryTime': '15-25 min',
        'category': 'Grocery Store',
        'distance': '0.8 km',
      },
      {
        'name': 'City Pharmacy',
        'image': 'assets/images/pharmacy1.jpg',
        'rating': 4.7,
        'deliveryTime': '10-15 min',
        'category': 'Medicine',
        'distance': '0.5 km',
      },
      {
        'name': 'Electronics Hub',
        'image': 'assets/images/electronics1.jpg',
        'rating': 4.2,
        'deliveryTime': '30-45 min',
        'category': 'Electronics',
        'distance': '2.1 km',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Shops in Vehari',
                  style: AppTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all shops
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return _buildShopCard(shop, index);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildShopCard(Map<String, dynamic> shop, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to shop details
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Shop Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Icon(
                  _getShopIcon(shop['category'] as String),
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Shop Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop['name'] as String,
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop['category'] as String,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop['rating'].toString(),
                          style: AppTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          shop['deliveryTime'] as String,
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Distance
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  shop['distance'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 100).ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.3, end: 0);
  }

  IconData _getShopIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pakistani food':
      case 'food':
        return Icons.restaurant;
      case 'grocery store':
      case 'grocery':
        return Icons.local_grocery_store;
      case 'medicine':
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'electronics':
        return Icons.devices;
      default:
        return Icons.store;
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Home - already here
            break;
          case 1:
            // Search
            break;
          case 2:
            // Orders
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrdersListScreen(),
              ),
            );
            break;
          case 3:
            // Profile
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _navigateToCategory(String categoryName) {
    String category;
    switch (categoryName.toLowerCase()) {
      case 'food':
        category = 'restaurant';
        break;
      case 'grocery':
        category = 'grocery';
        break;
      case 'pharmacy':
        category = 'pharmacy';
        break;
      case 'electronics':
        category = 'electronics';
        break;
      default:
        category = 'all';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopListingsScreen(category: category),
      ),
    );
  }
}
