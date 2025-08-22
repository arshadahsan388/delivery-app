import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create new order
  static Future<String> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore
          .collection(FirebaseCollections.orders)
          .add(order.toJson());
      
      // Update the order with the generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get orders for customer
  static Stream<List<OrderModel>> getCustomerOrders(String customerId) {
    return _firestore
        .collection(FirebaseCollections.orders)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get orders for rider
  static Stream<List<OrderModel>> getRiderOrders(String riderId) {
    return _firestore
        .collection(FirebaseCollections.orders)
        .where('riderId', isEqualTo: riderId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get pending orders for riders
  static Stream<List<OrderModel>> getPendingOrders() {
    return _firestore
        .collection(FirebaseCollections.orders)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Get all orders (for admin)
  static Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection(FirebaseCollections.orders)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  // Accept order (for rider)
  static Future<void> acceptOrder(String orderId, String riderId, String riderName) async {
    try {
      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'status': 'accepted',
        'riderId': riderId,
        'riderName': riderName,
        'acceptedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to accept order: $e');
    }
  }

  // Update order status
  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final Map<String, dynamic> updateData = {
        'status': status.toString().split('.').last,
      };

      // Add timestamp for specific statuses
      switch (status) {
        case OrderStatus.pickedUp:
          updateData['pickedUpAt'] = Timestamp.now();
          break;
        case OrderStatus.delivered:
          updateData['deliveredAt'] = Timestamp.now();
          break;
        default:
          break;
      }

      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Cancel order
  static Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .update({
        'status': 'cancelled',
        'metadata.cancellationReason': reason,
        'metadata.cancelledAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  // Get order by ID
  static Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.orders)
          .doc(orderId)
          .get();

      if (doc.exists) {
        return OrderModel.fromJson({...doc.data()!, 'id': doc.id});
      }
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
    return null;
  }

  // Get order statistics (for admin)
  static Future<Map<String, int>> getOrderStatistics() async {
    try {
      final QuerySnapshot allOrders = await _firestore
          .collection(FirebaseCollections.orders)
          .get();

      final Map<String, int> stats = {
        'total': allOrders.docs.length,
        'pending': 0,
        'accepted': 0,
        'preparing': 0,
        'pickedUp': 0,
        'onTheWay': 0,
        'delivered': 0,
        'cancelled': 0,
      };

      for (final doc in allOrders.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String? ?? 'pending';
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to get order statistics: $e');
    }
  }

  // Get orders by date range
  static Future<List<OrderModel>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(FirebaseCollections.orders)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders by date range: $e');
    }
  }
}
