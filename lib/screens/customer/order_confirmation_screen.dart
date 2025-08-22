import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../providers/custom_order_provider.dart';
import '../../providers/customer_order_provider.dart';
import '../../models/custom_order_model.dart';
import '../../models/order_model.dart';
import '../../utils/toast_helper.dart';
import '../../widgets/app_wrapper.dart';

class OrderConfirmationScreen extends ConsumerStatefulWidget {
  final String customOrder;
  final String address;
  final String phone;
  final String specialInstructions;

  const OrderConfirmationScreen({
    super.key,
    required this.customOrder,
    required this.address,
    required this.phone,
    required this.specialInstructions,
  });

  @override
  ConsumerState<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends ConsumerState<OrderConfirmationScreen> {
  bool _isSubmitting = false;

  Future<void> _confirmOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Generate customer ID and order ID
      final customerId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create OrderModel for both Firestore and customer order provider
      final orderModel = OrderModel(
        id: orderId,
        customerId: customerId,
        customerName: 'Guest Customer',
        customerPhone: widget.phone,
        customerAddress: widget.address,
        customerLatitude: 30.0444, // Default Vehari coordinates
        customerLongitude: 72.3570, // Default Vehari coordinates
        shopId: '',
        shopName: '',
        shopAddress: '',
        items: [
          OrderItem(
            name: widget.customOrder,
            description: '',
            quantity: 1,
            price: 0.0,
            notes: '',
          )
        ],
        specialInstructions: widget.specialInstructions.isNotEmpty ? widget.specialInstructions : null,
        images: [],
        status: OrderStatus.pending,
        riderId: null,
        riderName: null,
        paymentMethod: PaymentMethod.cashOnDelivery,
        totalAmount: 0.0,
        deliveryFee: 0.0,
        createdAt: DateTime.now(), // This will be converted to Timestamp in toJson()
        acceptedAt: null,
        pickedUpAt: null,
        deliveredAt: null,
        metadata: null,
      );

      // Save to Firestore using the OrderModel
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set(orderModel.toJson());

      // Set customer ID and create order in customer order provider
      ref.read(customerOrderProvider.notifier).setCustomerId(customerId);
      
      // Show success message
      ToastHelper.showSuccess(context, 'Order placed successfully! 🎉');

      // Navigate back to home through AppWrapper (proper navigation)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AppWrapper()),
        (route) => false,
      );

    } catch (e) {
      ToastHelper.showError(context, 'Failed to place order. Please try again.');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Confirm Your Order',
                      style: AppTheme.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Order Summary',
                            style: AppTheme.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Customer Details
                      _buildDetailSection(
                        icon: Icons.person,
                        title: 'Customer Information',
                        items: [
                          _buildDetailItem('Name', 'Guest Customer'),
                          _buildDetailItem('Email', 'guest@localexpress.com'),
                          _buildDetailItem('Phone', widget.phone),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Delivery Details
                      _buildDetailSection(
                        icon: Icons.location_on,
                        title: 'Delivery Information',
                        items: [
                          _buildDetailItem('Address', widget.address),
                          if (widget.specialInstructions.isNotEmpty)
                            _buildDetailItem('Special Instructions', widget.specialInstructions),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Order Details
                      _buildDetailSection(
                        icon: Icons.shopping_cart,
                        title: 'Order Details',
                        items: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              widget.customOrder,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textColor,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Important Note
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your order will be processed by our admin team and assigned to a nearby rider.',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Confirm Order Button
                CustomButton(
                  text: _isSubmitting ? 'Placing Order...' : 'Confirm Order',
                  onPressed: _isSubmitting ? null : _confirmOrder,
                  icon: _isSubmitting ? null : Icons.check_circle,
                  isLoading: _isSubmitting,
                ),

                const SizedBox(height: 16),

                // Cancel Button
                if (!_isSubmitting)
                  CustomButton(
                    text: 'Go Back',
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back,
                    backgroundColor: Colors.grey[600],
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
