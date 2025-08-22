import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/cart_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool _isApplyingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(
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
          if (cart.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(),
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: cart.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: cart.isNotEmpty ? _buildCheckoutBottomBar() : null,
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 120,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add some delicious items to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Start Shopping',
              onPressed: () => Navigator.pop(context),
              backgroundColor: AppTheme.primaryColor,
            ),
          ],
        ).animate().fadeIn().scale(),
      ),
    );
  }

  Widget _buildCartContent() {
    final cart = ref.watch(cartProvider);
    final itemsByShop = cart.itemsByShop;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Column(
        children: [
          // Cart Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itemsByShop.length,
              itemBuilder: (context, shopIndex) {
                final shopId = itemsByShop.keys.elementAt(shopIndex);
                final shopItems = itemsByShop[shopId]!;
                final shopName = shopItems.first.product.shopId; // In real app, get shop name

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.store,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getShopName(shopItems.first.product.category),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Shop Items
                    ...shopItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _buildCartItemCard(item, index);
                    }).toList(),

                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),

          // Coupon Section
          _buildCouponSection(),

          // Order Summary
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(dynamic item, int index) {
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getProductIcon(item.product.category),
                size: 30,
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
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.product.price.toStringAsFixed(0)} each',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (item.specialInstructions != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Note: ${item.specialInstructions}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
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
                          item.id,
                          item.quantity - 1,
                        ),
                        icon: const Icon(Icons.remove, size: 16),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cartNotifier.updateQuantity(
                          item.id,
                          item.quantity + 1,
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
                const SizedBox(height: 8),
                Text(
                  'Rs. ${item.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),

            // Remove Button
            IconButton(
              onPressed: () => cartNotifier.removeItem(item.id),
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red[600],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildCouponSection() {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          if (cart.couponCode != null) ...[
            // Applied Coupon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Coupon "${cart.couponCode}" applied',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '-Rs. ${cart.couponDiscount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => cartNotifier.removeCoupon(),
                    icon: Icon(Icons.close, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Coupon Input
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _couponController,
                    labelText: 'Coupon Code',
                    hintText: 'Enter coupon code',
                    prefixIcon: Icons.local_offer,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isApplyingCoupon ? null : _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: _isApplyingCoupon
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Apply'),
                ),
              ],
            ),
            
            // Available Coupons
            const SizedBox(height: 12),
            const Text(
              'Available Coupons:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildCouponChip('SAVE50', 'Rs. 50 off on orders above Rs. 500'),
                _buildCouponChip('FIRST10', '10% off on first order'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCouponChip(String code, String description) {
    return GestureDetector(
      onTap: () {
        _couponController.text = code;
        _applyCoupon();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Text(
          code,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final cart = ref.watch(cartProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSummaryRow('Subtotal', 'Rs. ${cart.subtotal.toStringAsFixed(0)}'),
          
          if (cart.couponDiscount > 0)
            _buildSummaryRow(
              'Coupon Discount',
              '-Rs. ${cart.couponDiscount.toStringAsFixed(0)}',
              isDiscount: true,
            ),
          
          _buildSummaryRow('Delivery Fee', 'Rs. ${cart.deliveryFee.toStringAsFixed(0)}'),
          
          const Divider(),
          
          _buildSummaryRow(
            'Total',
            'Rs. ${cart.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green[700] : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount ? Colors.green[700] : (isTotal ? AppTheme.primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBottomBar() {
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
        child: CustomButton(
          text: 'Proceed to Checkout • Rs. ${cart.total.toStringAsFixed(0)}',
          onPressed: _proceedToCheckout,
          backgroundColor: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void _applyCoupon() async {
    if (_couponController.text.trim().isEmpty) return;

    setState(() {
      _isApplyingCoupon = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final cartNotifier = ref.read(cartProvider.notifier);
    final couponCode = _couponController.text.trim().toUpperCase();
    
    // Demo coupon logic
    double discount = 0;
    bool isValid = false;
    
    switch (couponCode) {
      case 'SAVE50':
        if (ref.read(cartProvider).subtotal >= 500) {
          discount = 50;
          isValid = true;
        }
        break;
      case 'FIRST10':
        discount = ref.read(cartProvider).subtotal * 0.1;
        isValid = true;
        break;
    }

    if (isValid) {
      cartNotifier.applyCoupon(couponCode, discount);
      _couponController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon applied! You saved Rs. ${discount.toStringAsFixed(0)}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid or expired coupon code'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isApplyingCoupon = false;
    });
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(),
      ),
    );
  }

  String _getShopName(String category) {
    switch (category) {
      case 'vegetables':
      case 'grains':
      case 'dairy':
        return 'Fresh Mart Grocery';
      case 'medicine':
      case 'supplements':
        return 'Bismillah Pharmacy';
      case 'main_course':
      case 'rice':
        return 'Lahori Karahi';
      case 'smartphone':
        return 'Mobile Zone';
      default:
        return 'Shop';
    }
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
}
