import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier() : super(const OrdersState()) {
    listenToOrders(); // Start real-time listening instead of one-time load
    // Also try manual load as fallback
    _loadOrders();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load all orders
  Future<void> _loadOrders() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Get pending orders (not confirmed yet)
  List<OrderModel> get pendingOrders {
    return state.orders.where((order) => order.status == OrderStatus.pending).toList();
  }

  // Get confirmed orders
  List<OrderModel> get confirmedOrders {
    return state.orders.where((order) => order.status != OrderStatus.pending).toList();
  }

  // Confirm an order (admin action)
  Future<void> confirmOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': OrderStatus.accepted.name,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(
            status: OrderStatus.accepted,
            acceptedAt: DateTime.now(),
          );
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(error: 'Failed to confirm order: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final updateData = <String, dynamic>{
        'status': newStatus.name,
      };

      // Add timestamp for specific status changes
      switch (newStatus) {
        case OrderStatus.accepted:
          updateData['acceptedAt'] = FieldValue.serverTimestamp();
          break;
        case OrderStatus.pickedUp:
          updateData['pickedUpAt'] = FieldValue.serverTimestamp();
          break;
        case OrderStatus.delivered:
          updateData['deliveredAt'] = FieldValue.serverTimestamp();
          break;
        default:
          break;
      }

      await _firestore.collection('orders').doc(orderId).update(updateData);

      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: newStatus);
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update order status: $e');
    }
  }

  // Assign rider to order
  Future<void> assignRider(String orderId, String riderId, String riderName) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'riderId': riderId,
        'riderName': riderName,
        'status': OrderStatus.accepted.name,
      });

      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(
            riderId: riderId,
            riderName: riderName,
            status: OrderStatus.accepted,
          );
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(error: 'Failed to assign rider: $e');
    }
  }

  // Add new order (called when customer places order)
  Future<String> addOrder(OrderModel order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toJson());
      
      // Add to local state
      final newOrder = order.copyWith(id: docRef.id);
      state = state.copyWith(orders: [newOrder, ...state.orders]);
      
      return docRef.id;
    } catch (e) {
      state = state.copyWith(error: 'Failed to place order: $e');
      rethrow;
    }
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await _loadOrders();
  }

  // Listen to real-time order updates
  void listenToOrders() {
    print('OrdersProvider: Starting to listen to orders...');
    _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      try {
        print('OrdersProvider: Received ${snapshot.docs.length} documents');
        final orders = snapshot.docs
            .map((doc) {
              try {
                print('OrdersProvider: Processing document ${doc.id}');
                final data = doc.data();
                print('OrdersProvider: Raw document data: $data');
                
                final orderData = {...data, 'id': doc.id};
                final order = OrderModel.fromJson(orderData);
                print('OrdersProvider: Successfully parsed order ${order.id}');
                return order;
              } catch (e) {
                print('OrdersProvider: Error parsing document ${doc.id}: $e');
                return null;
              }
            })
            .where((order) => order != null)
            .cast<OrderModel>()
            .toList();

        print('OrdersProvider: Successfully parsed ${orders.length} orders');
        state = state.copyWith(orders: orders, isLoading: false, error: null);
      } catch (e) {
        print('OrdersProvider: Error parsing orders: $e');
        state = state.copyWith(error: e.toString());
      }
    }, onError: (error) {
      print('OrdersProvider: Snapshot error: $error');
      state = state.copyWith(error: error.toString());
    });
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for orders
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier();
});
