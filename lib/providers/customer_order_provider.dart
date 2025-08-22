import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class CustomerOrderState {
  final OrderModel? currentOrder;
  final bool isLoading;
  final String? error;

  const CustomerOrderState({
    this.currentOrder,
    this.isLoading = false,
    this.error,
  });

  CustomerOrderState copyWith({
    OrderModel? currentOrder,
    bool? isLoading,
    String? error,
    bool clearOrder = false,
  }) {
    return CustomerOrderState(
      currentOrder: clearOrder ? null : (currentOrder ?? this.currentOrder),
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CustomerOrderNotifier extends StateNotifier<CustomerOrderState> {
  CustomerOrderNotifier() : super(const CustomerOrderState()) {
    _listenToCurrentOrder();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentCustomerId;

  // Set current customer ID and listen to their orders
  void setCustomerId(String customerId) {
    _currentCustomerId = customerId;
    _listenToCurrentOrder();
  }

  // Listen to the current customer's active order
  void _listenToCurrentOrder() {
    if (_currentCustomerId == null) return;

    _firestore
        .collection('orders')
        .where('customerId', isEqualTo: _currentCustomerId)
        .where('status', whereIn: ['pending', 'accepted', 'pickedUp']) // Only active orders
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      try {
        if (snapshot.docs.isNotEmpty) {
          final orderData = snapshot.docs.first.data();
          final order = OrderModel.fromJson({...orderData, 'id': snapshot.docs.first.id});
          state = state.copyWith(currentOrder: order, isLoading: false, error: null);
        } else {
          state = state.copyWith(clearOrder: true, isLoading: false, error: null);
        }
      } catch (e) {
        state = state.copyWith(error: e.toString());
      }
    });
  }

  // Create a new order and set it as current
  Future<void> createOrder(OrderModel order) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final docRef = await _firestore.collection('orders').add(order.toJson());
      final newOrder = order.copyWith(id: docRef.id);
      
      state = state.copyWith(currentOrder: newOrder, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to create order: $e', isLoading: false);
      rethrow;
    }
  }

  // Clear current order (when delivered or cancelled)
  void clearCurrentOrder() {
    state = state.copyWith(clearOrder: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for customer current order
final customerOrderProvider = StateNotifierProvider<CustomerOrderNotifier, CustomerOrderState>((ref) {
  return CustomerOrderNotifier();
});
