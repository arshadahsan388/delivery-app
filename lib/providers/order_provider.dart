import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../services/order_service.dart';
import 'auth_provider.dart';

// Orders for current user (customer/rider)
final userOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  
  return user.when(
    data: (userData) {
      if (userData == null) return Stream.value([]);
      
      switch (userData.role) {
        case UserRole.customer:
          return OrderService.getCustomerOrders(userData.id);
        case UserRole.rider:
          return OrderService.getRiderOrders(userData.id);
        case UserRole.admin:
          return OrderService.getAllOrders();
      }
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

// Pending orders for riders
final pendingOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return OrderService.getPendingOrders();
});

// All orders for admin
final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return OrderService.getAllOrders();
});

// Order statistics for admin
final orderStatisticsProvider = FutureProvider<Map<String, int>>((ref) {
  return OrderService.getOrderStatistics();
});

// Order controller
class OrderController extends StateNotifier<AsyncValue<void>> {
  OrderController() : super(const AsyncValue.data(null));

  Future<String> createOrder(OrderModel order) async {
    state = const AsyncValue.loading();
    try {
      final orderId = await OrderService.createOrder(order);
      state = const AsyncValue.data(null);
      return orderId;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> acceptOrder(String orderId, String riderId, String riderName) async {
    state = const AsyncValue.loading();
    try {
      await OrderService.acceptOrder(orderId, riderId, riderName);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    state = const AsyncValue.loading();
    try {
      await OrderService.updateOrderStatus(orderId, status);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    state = const AsyncValue.loading();
    try {
      await OrderService.cancelOrder(orderId, reason);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

// Order controller provider
final orderControllerProvider = StateNotifierProvider<OrderController, AsyncValue<void>>((ref) {
  return OrderController();
});

// Individual order provider
final orderProvider = FutureProvider.family<OrderModel?, String>((ref, orderId) {
  return OrderService.getOrderById(orderId);
});
