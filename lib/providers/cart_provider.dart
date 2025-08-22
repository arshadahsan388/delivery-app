import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart(items: []));

  static const _uuid = Uuid();

  // Add item to cart
  void addItem(Product product, {
    int quantity = 1,
    Map<String, dynamic>? selectedVariants,
    String? specialInstructions,
  }) {
    final existingItemIndex = state.items.indexWhere(
      (item) => 
        item.product.id == product.id &&
        _variantsMatch(item.selectedVariants, selectedVariants),
    );

    if (existingItemIndex >= 0) {
      // Update existing item quantity
      final updatedItems = [...state.items];
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
        quantity: updatedItems[existingItemIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        id: _uuid.v4(),
        product: product,
        quantity: quantity,
        selectedVariants: selectedVariants,
        specialInstructions: specialInstructions,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  // Remove item from cart
  void removeItem(String itemId) {
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
  }

  // Update item quantity
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Clear entire cart
  void clearCart() {
    state = Cart(items: []);
  }

  // Apply coupon
  void applyCoupon(String couponCode, double discount) {
    state = state.copyWith(
      couponCode: couponCode,
      couponDiscount: discount,
    );
  }

  // Remove coupon
  void removeCoupon() {
    state = state.copyWith(
      couponCode: null,
      couponDiscount: 0.0,
    );
  }

  // Update delivery fee
  void updateDeliveryFee(double fee) {
    state = state.copyWith(deliveryFee: fee);
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        id: '',
        product: Product(
          id: '',
          shopId: '',
          name: '',
          description: '',
          imageUrl: '',
          price: 0,
          category: '',
          isAvailable: false,
          stock: 0,
          tags: [],
          rating: 0,
          reviewCount: 0,
          isFeatured: false,
          createdAt: DateTime.now(),
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  // Helper method to compare variants
  bool _variantsMatch(Map<String, dynamic>? variants1, Map<String, dynamic>? variants2) {
    if (variants1 == null && variants2 == null) return true;
    if (variants1 == null || variants2 == null) return false;
    
    if (variants1.length != variants2.length) return false;
    
    for (final key in variants1.keys) {
      if (!variants2.containsKey(key) || variants1[key] != variants2[key]) {
        return false;
      }
    }
    return true;
  }
}

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});

// Derived providers for convenience
final cartItemsCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.totalItems;
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.total;
});

final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.subtotal;
});
