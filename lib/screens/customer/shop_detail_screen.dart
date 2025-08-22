import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/shop_model.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import 'cart_screen.dart';

class ShopDetailScreen extends ConsumerStatefulWidget {
  final ShopModel shop;

  const ShopDetailScreen({
    super.key,
    required this.shop,
  });

  @override
  ConsumerState<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends ConsumerState<ShopDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // Demo products - In real app, fetch from API based on shop ID
  late List<Product> _demoProducts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeDemoProducts();
  }

  void _initializeDemoProducts() {
    if (widget.shop.categories.contains('grocery')) {
      _demoProducts = [
        Product(
          id: 'p1',
          shopId: widget.shop.id,
          name: 'Fresh Tomatoes',
          description: 'Taza tamatar, daily fresh',
          imageUrl: '',
          price: 80.0,
          originalPrice: 100.0,
          category: 'vegetables',
          isAvailable: true,
          stock: 50,
          tags: ['fresh', 'vegetables', 'daily'],
          rating: 4.5,
          reviewCount: 120,
          isFeatured: true,
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'p2',
          shopId: widget.shop.id,
          name: 'Basmati Rice 5kg',
          description: 'Premium quality basmati chawal',
          imageUrl: '',
          price: 1200.0,
          category: 'grains',
          isAvailable: true,
          stock: 25,
          tags: ['rice', 'basmati', 'premium'],
          rating: 4.7,
          reviewCount: 85,
          isFeatured: false,
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'p3',
          shopId: widget.shop.id,
          name: 'Fresh Milk 1L',
          description: 'Pure aur fresh doodh',
          imageUrl: '',
          price: 120.0,
          category: 'dairy',
          isAvailable: true,
          stock: 30,
          tags: ['milk', 'fresh', 'dairy'],
          rating: 4.3,
          reviewCount: 200,
          isFeatured: true,
          createdAt: DateTime.now(),
        ),
      ];
    } else if (widget.shop.categories.contains('pharmacy')) {
      _demoProducts = [
        Product(
          id: 'p4',
          shopId: widget.shop.id,
          name: 'Panadol Tablets',
          description: 'Bukhar aur dard ki dawa',
          imageUrl: '',
          price: 15.0,
          category: 'medicine',
          isAvailable: true,
          stock: 100,
          tags: ['medicine', 'painkiller', 'fever'],
          rating: 4.8,
          reviewCount: 95,
          isFeatured: true,
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'p5',
          shopId: widget.shop.id,
          name: 'Vitamin D3 Tablets',
          description: 'Vitamin D ki kami puri kare',
          imageUrl: '',
          price: 250.0,
          category: 'supplements',
          isAvailable: true,
          stock: 40,
          tags: ['vitamin', 'supplements', 'health'],
          rating: 4.6,
          reviewCount: 67,
          isFeatured: false,
          createdAt: DateTime.now(),
        ),
      ];
    } else if (widget.shop.categories.contains('restaurant')) {
      _demoProducts = [
        Product(
          id: 'p6',
          shopId: widget.shop.id,
          name: 'Chicken Karahi',
          description: 'Special lahori karahi with naan',
          imageUrl: '',
          price: 800.0,
          originalPrice: 900.0,
          category: 'main_course',
          isAvailable: true,
          stock: 20,
          tags: ['chicken', 'karahi', 'spicy'],
          rating: 4.9,
          reviewCount: 350,
          isFeatured: true,
          createdAt: DateTime.now(),
        ),
        Product(
          id: 'p7',
          shopId: widget.shop.id,
          name: 'Beef Pulao',
          description: 'Basmati rice with tender beef',
          imageUrl: '',
          price: 600.0,
          category: 'rice',
          isAvailable: true,
          stock: 15,
          tags: ['beef', 'pulao', 'rice'],
          rating: 4.4,
          reviewCount: 180,
          isFeatured: false,
          createdAt: DateTime.now(),
        ),
      ];
    } else {
      _demoProducts = [
        Product(
          id: 'p8',
          shopId: widget.shop.id,
          name: 'Samsung Galaxy A54',
          description: 'Latest smartphone with great camera',
          imageUrl: '',
          price: 45000.0,
          originalPrice: 50000.0,
          category: 'smartphone',
          isAvailable: true,
          stock: 10,
          tags: ['samsung', 'smartphone', 'android'],
          rating: 4.6,
          reviewCount: 45,
          isFeatured: true,
          createdAt: DateTime.now(),
        ),
      ];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartItemsCount = ref.watch(cartItemsCountProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Shop Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              // Cart Icon with Badge
              Stack(
                children: [
                  IconButton(
                    onPressed: () => _navigateToCart(),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  if (cartItemsCount > 0)
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
                          '$cartItemsCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getShopIcon(),
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.shop.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.shop.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Shop Info
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Rating and Info Row
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange[400], size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.shop.rating}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.shop.totalOrders} orders)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: widget.shop.isActive ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.shop.isActive ? 'Open' : 'Closed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Address
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.shop.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Phone
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        widget.shop.phone,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Products'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Info'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildReviewsTab(),
                _buildInfoTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: cartItemsCount > 0 ? _buildCartBottomBar() : null,
    );
  }

  Widget _buildProductsTab() {
    final categories = _getProductCategories();
    
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Categories Filter
          if (categories.length > 1)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(category),
                      selected: false,
                      onSelected: (selected) {
                        // Filter by category
                      },
                    ),
                  );
                },
              ),
            ),

          // Products List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _demoProducts.length,
              itemBuilder: (context, index) {
                final product = _demoProducts[index];
                return _buildProductCard(product, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, int index) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final isInCart = ref.read(cartProvider).items.any((item) => item.product.id == product.id);
    final quantity = ref.read(cartProvider).items
        .where((item) => item.product.id == product.id)
        .fold(0, (sum, item) => sum + item.quantity);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getProductIcon(product.category),
                size: 40,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(width: 16),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
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
                      if (product.isOnSale) ...[
                        Text(
                          'Rs. ${product.originalPrice?.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'Rs. ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      if (product.isOnSale)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            Column(
              children: [
                if (!isInCart)
                  ElevatedButton(
                    onPressed: product.isAvailable
                        ? () => cartNotifier.addItem(product)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => cartNotifier.updateQuantity(
                            ref.read(cartProvider).items
                                .firstWhere((item) => item.product.id == product.id)
                                .id,
                            quantity - 1,
                          ),
                          icon: const Icon(Icons.remove, size: 16),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => cartNotifier.updateQuantity(
                            ref.read(cartProvider).items
                                .firstWhere((item) => item.product.id == product.id)
                                .id,
                            quantity + 1,
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                
                if (!product.isAvailable)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildReviewsTab() {
    return const Center(
      child: Text(
        'Reviews coming soon...',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opening Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.shop.openingHours.entries.map((entry) {
            final day = entry.key;
            final hours = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day.substring(0, 1).toUpperCase() + day.substring(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${hours['open']} - ${hours['close']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCartBottomBar() {
    final cart = ref.watch(cartProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cart.totalItems} items',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Rs. ${cart.subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'View Cart',
                onPressed: _navigateToCart,
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getProductCategories() {
    return _demoProducts.map((p) => p.category).toSet().toList();
  }

  IconData _getShopIcon() {
    if (widget.shop.categories.contains('grocery')) return Icons.shopping_cart;
    if (widget.shop.categories.contains('pharmacy')) return Icons.local_pharmacy;
    if (widget.shop.categories.contains('restaurant')) return Icons.restaurant;
    if (widget.shop.categories.contains('electronics')) return Icons.phone_android;
    return Icons.store;
  }

  IconData _getProductIcon(String category) {
    switch (category) {
      case 'vegetables':
        return Icons.eco;
      case 'grains':
        return Icons.grain;
      case 'dairy':
        return Icons.local_drink;
      case 'medicine':
        return Icons.medication;
      case 'supplements':
        return Icons.medical_services;
      case 'main_course':
        return Icons.restaurant_menu;
      case 'rice':
        return Icons.rice_bowl;
      case 'smartphone':
        return Icons.smartphone;
      default:
        return Icons.shopping_bag;
    }
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
