import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/shop_model.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import 'shop_detail_screen.dart';

class ShopListingsScreen extends ConsumerStatefulWidget {
  final String category;
  
  const ShopListingsScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<ShopListingsScreen> createState() => _ShopListingsScreenState();
}

class _ShopListingsScreenState extends ConsumerState<ShopListingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'rating'; // rating, distance, delivery_time
  
  // Demo data - In real app, this would come from API/Firebase
  final List<ShopModel> _demoShops = [
    ShopModel(
      id: '1',
      name: 'Fresh Mart Grocery',
      description: 'Taza vegetables aur fruits daily fresh',
      logo: '',
      coverImage: '',
      address: 'Main Bazaar, Vehari',
      latitude: 30.0448,
      longitude: 72.3478,
      phone: '+92 300 1234567',
      email: 'freshmart@gmail.com',
      categories: ['grocery', 'vegetables', 'fruits'],
      isActive: true,
      openingHours: {
        'monday': {'open': '08:00', 'close': '22:00'},
        'tuesday': {'open': '08:00', 'close': '22:00'},
        'wednesday': {'open': '08:00', 'close': '22:00'},
        'thursday': {'open': '08:00', 'close': '22:00'},
        'friday': {'open': '08:00', 'close': '22:00'},
        'saturday': {'open': '08:00', 'close': '22:00'},
        'sunday': {'open': '09:00', 'close': '21:00'},
      },
      rating: 4.5,
      totalOrders: 1250,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ownerId: 'owner1',
    ),
    ShopModel(
      id: '2',
      name: 'Bismillah Pharmacy',
      description: 'Medicines aur health care products',
      logo: '',
      coverImage: '',
      address: 'Hospital Road, Vehari',
      latitude: 30.0458,
      longitude: 72.3488,
      phone: '+92 300 7654321',
      email: 'bismillah@pharmacy.com',
      categories: ['pharmacy', 'medicines', 'health'],
      isActive: true,
      openingHours: {
        'monday': {'open': '07:00', 'close': '23:00'},
        'tuesday': {'open': '07:00', 'close': '23:00'},
        'wednesday': {'open': '07:00', 'close': '23:00'},
        'thursday': {'open': '07:00', 'close': '23:00'},
        'friday': {'open': '07:00', 'close': '23:00'},
        'saturday': {'open': '07:00', 'close': '23:00'},
        'sunday': {'open': '08:00', 'close': '22:00'},
      },
      rating: 4.8,
      totalOrders: 890,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ownerId: 'owner2',
    ),
    ShopModel(
      id: '3',
      name: 'Lahori Karahi',
      description: 'Desi food aur BBQ specialist',
      logo: '',
      coverImage: '',
      address: 'Food Street, Vehari',
      latitude: 30.0438,
      longitude: 72.3468,
      phone: '+92 300 1111222',
      email: 'lahori@food.com',
      categories: ['restaurant', 'desi', 'bbq'],
      isActive: true,
      openingHours: {
        'monday': {'open': '12:00', 'close': '23:30'},
        'tuesday': {'open': '12:00', 'close': '23:30'},
        'wednesday': {'open': '12:00', 'close': '23:30'},
        'thursday': {'open': '12:00', 'close': '23:30'},
        'friday': {'open': '12:00', 'close': '24:00'},
        'saturday': {'open': '12:00', 'close': '24:00'},
        'sunday': {'open': '12:00', 'close': '23:30'},
      },
      rating: 4.3,
      totalOrders: 2100,
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
      ownerId: 'owner3',
    ),
    ShopModel(
      id: '4',
      name: 'Mobile Zone',
      description: 'Mobiles aur accessories ki shop',
      logo: '',
      coverImage: '',
      address: 'Electronics Market, Vehari',
      latitude: 30.0468,
      longitude: 72.3498,
      phone: '+92 300 9999888',
      email: 'mobile@zone.com',
      categories: ['electronics', 'mobile', 'accessories'],
      isActive: true,
      openingHours: {
        'monday': {'open': '10:00', 'close': '21:00'},
        'tuesday': {'open': '10:00', 'close': '21:00'},
        'wednesday': {'open': '10:00', 'close': '21:00'},
        'thursday': {'open': '10:00', 'close': '21:00'},
        'friday': {'open': '10:00', 'close': '21:00'},
        'saturday': {'open': '10:00', 'close': '21:00'},
        'sunday': {'open': '11:00', 'close': '20:00'},
      },
      rating: 4.1,
      totalOrders: 670,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      ownerId: 'owner4',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ShopModel> get _filteredShops {
    var shops = _demoShops.where((shop) {
      // Filter by category
      if (widget.category != 'all' && !shop.categories.contains(widget.category)) {
        return false;
      }
      
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        return shop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               shop.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               shop.categories.any((cat) => cat.toLowerCase().contains(_searchQuery.toLowerCase()));
      }
      
      return true;
    }).toList();

    // Sort shops
    switch (_sortBy) {
      case 'rating':
        shops.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        // In real app, calculate actual distance
        shops.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'delivery_time':
        // In real app, use actual delivery time
        shops.sort((a, b) => a.totalOrders.compareTo(b.totalOrders));
        break;
    }

    return shops;
  }

  @override
  Widget build(BuildContext context) {
    final filteredShops = _filteredShops;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getCategoryTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: const Icon(Icons.sort, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                controller: _searchController,
                labelText: 'Search',
                hintText: 'Search shops...',
                prefixIcon: Icons.search,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Shop Count & Sort Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredShops.length} shops found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Sorted by: ${_getSortDisplayName()}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Shop Listings
            Expanded(
              child: filteredShops.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredShops.length,
                      itemBuilder: (context, index) {
                        final shop = filteredShops[index];
                        return _buildShopCard(shop, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(ShopModel shop, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToShopDetail(shop),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Shop Logo/Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(shop.categories.first),
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(width: 16),

                // Shop Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shop.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${shop.rating}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${shop.totalOrders} orders)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              shop.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status & Arrow
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: shop.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        shop.isActive ? 'Open' : 'Closed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No shops found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption('rating', 'Rating', Icons.star),
            _buildSortOption('distance', 'Distance', Icons.location_on),
            _buildSortOption('delivery_time', 'Popularity', Icons.trending_up),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String title, IconData icon) {
    final isSelected = _sortBy == value;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppTheme.primaryColor)
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  String _getCategoryTitle() {
    switch (widget.category) {
      case 'grocery':
        return 'Grocery Stores';
      case 'pharmacy':
        return 'Pharmacies';
      case 'restaurant':
        return 'Restaurants';
      case 'electronics':
        return 'Electronics';
      default:
        return 'All Shops';
    }
  }

  String _getSortDisplayName() {
    switch (_sortBy) {
      case 'rating':
        return 'Rating';
      case 'distance':
        return 'Distance';
      case 'delivery_time':
        return 'Popularity';
      default:
        return 'Rating';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'grocery':
        return Icons.shopping_cart;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'restaurant':
        return Icons.restaurant;
      case 'electronics':
        return Icons.phone_android;
      default:
        return Icons.store;
    }
  }

  void _navigateToShopDetail(ShopModel shop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopDetailScreen(shop: shop),
      ),
    );
  }
}
