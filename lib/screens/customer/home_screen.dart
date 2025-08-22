import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/hybrid_auth_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/locale_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/localization.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/shop_card.dart';
import '../../widgets/order_card.dart';
import '../../widgets/quick_action_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final auth = ref.watch(hybridAuthProvider);
    final orders = ref.watch(ordersProvider);
    final isUrdu = ref.watch(isUrduProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  auth.user != null 
                                    ? 'Welcome back,\n${auth.user?.name ?? 'User'}!'
                                    : 'Welcome back!',
                                  style: AppTheme.headingMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Language Toggle
                              IconButton(
                                onPressed: () {
                                  ref.read(localeProvider.notifier).toggleLanguage();
                                },
                                icon: const Icon(
                                  Icons.language,
                                  color: Colors.white,
                                ),
                              ),
                              // Notifications
                              IconButton(
                                onPressed: () {
                                  // TODO: Navigate to notifications
                                },
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: AppTheme.headingSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            title: 'Order Food',
                            subtitle: 'From nearby shops',
                            icon: Icons.restaurant,
                            color: AppTheme.primaryColor,
                            onTap: () => context.push('/customer/shops'),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 300.ms)
                              .slideY(begin: 0.3, end: 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: QuickActionCard(
                            title: 'Order History',
                            subtitle: 'View past orders',
                            icon: Icons.history,
                            color: AppTheme.secondaryColor,
                            onTap: () => context.push('/customer/orders'),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 400.ms)
                              .slideY(begin: 0.3, end: 0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Nearby Shops Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations?.nearbyShops ?? 'Nearby Shops',
                          style: AppTheme.headingSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 500.ms)
                            .slideX(begin: -0.3, end: 0),
                        
                        TextButton(
                          onPressed: () => context.push('/customer/shops'),
                          child: Text(
                            'See All',
                            style: AppTheme.labelLarge.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 600.ms),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Featured Shops (Mock Data)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 16,
                              left: index == 0 ? 0 : 0,
                            ),
                            child: SizedBox(
                              width: 160,
                              child: ShopCard(
                                name: 'Shop ${index + 1}',
                                description: 'Delicious food and fast delivery',
                                imageUrl: null, // Placeholder
                                rating: 4.5 + (index * 0.1),
                                onTap: () => context.push('/customer/order/shop${index + 1}'),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: (700 + index * 100).ms)
                              .slideX(begin: 0.3, end: 0);
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Recent Orders Section
                    Text(
                      localizations?.recentOrders ?? 'Recent Orders',
                      style: AppTheme.headingSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1200.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 16),

                    // Orders List
                    if (orders.orders.isEmpty) 
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No orders yet',
                              style: AppTheme.bodyLarge.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start by ordering from nearby shops',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 1300.ms)
                      .slideY(begin: 0.3, end: 0)
                    else
                      Column(
                        children: orders.orders.take(3).map((order) {
                          final index = orders.orders.indexOf(order);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: OrderCard(
                              order: order,
                              onTap: () {
                                // TODO: Navigate to order details
                              },
                            )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: (1300 + index * 100).ms)
                            .slideX(begin: 0.3, end: 0),
                          );
                        }).toList(),
                      ),
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, ref, localizations),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, WidgetRef ref, AppLocalizations? localizations) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey[400],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/customer/orders');
              break;
            case 2:
              context.push('/customer/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: localizations?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            activeIcon: const Icon(Icons.shopping_bag),
            label: localizations?.orders ?? 'Orders',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            activeIcon: const Icon(Icons.person),
            label: localizations?.profile ?? 'Profile',
          ),
        ],
      ),
    );
  }
}
