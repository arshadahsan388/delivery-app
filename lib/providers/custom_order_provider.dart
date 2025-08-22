import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/custom_order_model.dart';

// Custom Order state for managing custom orders
class CustomOrderState {
  final List<CustomOrderModel> orders;
  final bool isLoading;
  final String? error;
  final int newOrdersCount;

  const CustomOrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.newOrdersCount = 0,
  });

  CustomOrderState copyWith({
    List<CustomOrderModel>? orders,
    bool? isLoading,
    String? error,
    int? newOrdersCount,
  }) {
    return CustomOrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      newOrdersCount: newOrdersCount ?? this.newOrdersCount,
    );
  }
}

// Custom Order provider
final customOrderProvider = StateNotifierProvider<CustomOrderNotifier, CustomOrderState>((ref) {
  return CustomOrderNotifier();
});

class CustomOrderNotifier extends StateNotifier<CustomOrderState> {
  CustomOrderNotifier() : super(const CustomOrderState());

  // Place a new custom order
  Future<void> placeOrder(CustomOrderModel order) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate placing order
      await Future.delayed(const Duration(seconds: 1));

      // Add order to the list
      final updatedOrders = [order, ...state.orders];
      
      // Calculate new orders count (pending orders)
      final newOrdersCount = updatedOrders
          .where((o) => o.status == CustomOrderStatus.pending)
          .length;

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
        newOrdersCount: newOrdersCount,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to place order: ${e.toString()}',
      );
      rethrow;
    }
  }

  // Update order status (for admin use)
  Future<void> updateOrderStatus(String orderId, CustomOrderStatus newStatus) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(
            status: newStatus,
            confirmedAt: newStatus == CustomOrderStatus.confirmed 
                ? DateTime.now() 
                : order.confirmedAt,
            deliveredAt: newStatus == CustomOrderStatus.delivered 
                ? DateTime.now() 
                : order.deliveredAt,
          );
        }
        return order;
      }).toList();

      // Calculate new orders count
      final newOrdersCount = updatedOrders
          .where((o) => o.status == CustomOrderStatus.pending)
          .length;

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
        newOrdersCount: newOrdersCount,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update order: ${e.toString()}',
      );
    }
  }

  // Assign rider to order
  Future<void> assignRider(String orderId, String riderId, String riderName) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(
            riderId: riderId,
            riderName: riderName,
            status: CustomOrderStatus.confirmed,
            confirmedAt: DateTime.now(),
          );
        }
        return order;
      }).toList();

      // Calculate new orders count
      final newOrdersCount = updatedOrders
          .where((o) => o.status == CustomOrderStatus.pending)
          .length;

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
        newOrdersCount: newOrdersCount,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to assign rider: ${e.toString()}',
      );
    }
  }

  // Set estimated price
  Future<void> setEstimatedPrice(String orderId, double price) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(estimatedPrice: price);
        }
        return order;
      }).toList();

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to set price: ${e.toString()}',
      );
    }
  }

  // Add admin notes
  Future<void> addAdminNotes(String orderId, String notes) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(adminNotes: notes);
        }
        return order;
      }).toList();

      state = state.copyWith(
        orders: updatedOrders,
        isLoading: false,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add notes: ${e.toString()}',
      );
    }
  }

  // Get orders by status
  List<CustomOrderModel> getOrdersByStatus(CustomOrderStatus status) {
    return state.orders.where((order) => order.status == status).toList();
  }

  // Get orders by customer
  List<CustomOrderModel> getOrdersByCustomer(String customerId) {
    return state.orders.where((order) => order.customerId == customerId).toList();
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Mark notifications as read (reset new orders count)
  void markNotificationsAsRead() {
    state = state.copyWith(newOrdersCount: 0);
  }
}
