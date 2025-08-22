import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../providers/mock_firebase_auth_provider.dart';
import '../../providers/custom_order_provider.dart';
import '../../utils/toast_helper.dart';
import 'order_confirmation_screen.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final String customOrder;

  const OrderDetailsScreen({
    super.key,
    required this.customOrder,
  });

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialInstructionsController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  void _proceedToConfirmation() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            customOrder: widget.customOrder,
            address: _addressController.text.trim(),
            phone: _phoneController.text.trim(),
            specialInstructions: _specialInstructionsController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(mockFirebaseAuthProvider).user;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Order Details',
                        style: AppTheme.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Custom Order Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Your Custom Order',
                              style: AppTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Customer Information
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Delivery Information',
                              style: AppTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Customer Name (Read-only)
                        CustomTextField(
                          controller: TextEditingController(text: user?.name ?? 'Customer'),
                          labelText: 'Customer Name',
                          readOnly: true,
                          prefixIcon: Icons.person_outline,
                        ),

                        const SizedBox(height: 16),

                        // Delivery Address
                        CustomTextField(
                          labelText: 'Delivery Address',
                          controller: _addressController,
                          prefixIcon: Icons.location_on_outlined,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter delivery address';
                            }
                            if (value.trim().length < 10) {
                              return 'Please enter complete address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Phone Number
                        CustomTextField(
                          labelText: 'Phone Number',
                          controller: _phoneController,
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.trim().length < 10) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Special Instructions
                        CustomTextField(
                          labelText: 'Special Instructions for Rider (Optional)',
                          controller: _specialInstructionsController,
                          prefixIcon: Icons.note_outlined,
                          maxLines: 4,
                          hintText: 'e.g., Ring doorbell twice, Leave at door, Call upon arrival...',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Proceed Button
                  CustomButton(
                    text: 'Proceed to Confirmation',
                    onPressed: _proceedToConfirmation,
                    icon: Icons.arrow_forward,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
