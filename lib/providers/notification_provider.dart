import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier() : super([]) {
    _initializeMockNotifications();
    _startNotificationSimulation();
  }

  Timer? _simulationTimer;

  final List<Map<String, dynamic>> _mockNotificationTemplates = [
    {
      'title': 'Order Confirmed!',
      'message': 'Your order from {shopName} has been confirmed and is being prepared.',
      'type': NotificationType.orderUpdate,
      'priority': NotificationPriority.high,
    },
    {
      'title': 'Order Picked Up',
      'message': 'Your order is on its way! Expected delivery in 20-30 minutes.',
      'type': NotificationType.delivery,
      'priority': NotificationPriority.high,
    },
    {
      'title': 'Order Delivered!',
      'message': 'Your order has been delivered successfully. Enjoy your meal!',
      'type': NotificationType.delivery,
      'priority': NotificationPriority.high,
    },
    {
      'title': 'Special Offer!',
      'message': '🍕 Get 30% off on your next pizza order. Limited time offer!',
      'type': NotificationType.promotion,
      'priority': NotificationPriority.medium,
    },
    {
      'title': 'Payment Successful',
      'message': 'Your payment has been processed successfully.',
      'type': NotificationType.payment,
      'priority': NotificationPriority.medium,
    },
    {
      'title': 'Delivery Partner Assigned',
      'message': 'Ahmed Ali is heading to pick up your order. Track your delivery!',
      'type': NotificationType.delivery,
      'priority': NotificationPriority.medium,
    },
  ];

  void _initializeMockNotifications() {
    final now = DateTime.now();
    
    final mockNotifications = [
      NotificationModel(
        id: 'notif_001',
        title: 'Welcome to Local Express!',
        message: 'Start ordering from your favorite local restaurants.',
        type: NotificationType.general,
        priority: NotificationPriority.medium,
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: 'notif_002',
        title: 'Order Delivered',
        message: 'Your order from Pizza Palace has been delivered!',
        type: NotificationType.delivery,
        priority: NotificationPriority.high,
        createdAt: now.subtract(const Duration(hours: 1)),
        orderId: 'ord_001',
        isRead: true,
      ),
      NotificationModel(
        id: 'notif_003',
        title: '🎉 Flash Sale!',
        message: 'Up to 50% off on selected restaurants. Order now!',
        type: NotificationType.promotion,
        priority: NotificationPriority.medium,
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
        expiresAt: now.add(const Duration(hours: 6)),
      ),
    ];

    state = mockNotifications;
  }

  void _startNotificationSimulation() {
    // Simulate real-time notifications every 60-90 seconds for demo
    _simulationTimer = Timer.periodic(const Duration(seconds: 75), (timer) {
      if (state.length < 15) { // Limit to prevent spam
        _simulateNewNotification();
      }
    });
  }

  void _simulateNewNotification() {
    final template = _mockNotificationTemplates[
        DateTime.now().millisecond % _mockNotificationTemplates.length];
    
    final notification = NotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: template['title'],
      message: template['message'].toString().replaceAll('{shopName}', 'Demo Restaurant'),
      type: template['type'],
      priority: template['priority'],
      createdAt: DateTime.now(),
      isRead: false,
      orderId: template['type'] == NotificationType.orderUpdate || 
               template['type'] == NotificationType.delivery
          ? 'ord_${DateTime.now().millisecond}'
          : null,
    );

    addNotification(notification);
  }

  void addNotification(NotificationModel notification) {
    state = [notification, ...state];
  }

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
  }

  void deleteNotification(String notificationId) {
    state = state.where((notification) => notification.id != notificationId).toList();
  }

  void clearAllNotifications() {
    state = [];
  }

  void sendOrderStatusNotification(String orderId, String status, String shopName) {
    String title;
    String message;
    NotificationPriority priority = NotificationPriority.high;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        title = 'Order Confirmed!';
        message = 'Your order from $shopName has been confirmed and is being prepared.';
        break;
      case 'preparing':
        title = 'Order Being Prepared';
        message = '$shopName is preparing your delicious order.';
        break;
      case 'ready':
        title = 'Order Ready!';
        message = 'Your order is ready for pickup from $shopName.';
        break;
      case 'picked_up':
      case 'pickedup':
        title = 'Order Picked Up';
        message = 'Your order is on its way! Expected delivery in 20-30 minutes.';
        break;
      case 'on_the_way':
      case 'ontheway':
        title = 'Order On the Way';
        message = 'Your delivery partner is heading your way with your order!';
        break;
      case 'delivered':
        title = 'Order Delivered!';
        message = 'Your order has been delivered successfully. Enjoy your meal!';
        break;
      case 'cancelled':
        title = 'Order Cancelled';
        message = 'Your order from $shopName has been cancelled.';
        priority = NotificationPriority.medium;
        break;
      default:
        title = 'Order Update';
        message = 'Your order status has been updated.';
    }

    final notification = NotificationModel(
      id: 'order_${orderId}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: NotificationType.orderUpdate,
      priority: priority,
      createdAt: DateTime.now(),
      isRead: false,
      orderId: orderId,
    );

    addNotification(notification);
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}

// Providers
final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>(
  (ref) => NotificationNotifier(),
);

final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((notification) => !notification.isRead).toList();
});

final unreadCountProvider = Provider<int>((ref) {
  final unreadNotifications = ref.watch(unreadNotificationsProvider);
  return unreadNotifications.length;
});

final notificationByIdProvider = Provider.family<NotificationModel?, String>((ref, id) {
  final notifications = ref.watch(notificationProvider);
  try {
    return notifications.firstWhere((notification) => notification.id == id);
  } catch (e) {
    return null;
  }
});
