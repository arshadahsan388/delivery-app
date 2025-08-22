import 'package:cloud_firestore/cloud_firestore.dart';

class TestOrderCreator {
  static Future<void> createTestOrder() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Create a test order
      final testOrder = {
        'id': 'test_order_123',
        'customerId': 'test_customer',
        'customerName': 'Test Customer',
        'customerPhone': '+92123456789',
        'customerAddress': 'Test Address, Vehari',
        'customerLatitude': 30.0444,
        'customerLongitude': 72.3570,
        'shopId': '',
        'shopName': '',
        'shopAddress': '',
        'items': [
          {
            'name': 'Test Item',
            'description': 'Test Description',
            'quantity': 1,
            'price': 100.0,
            'notes': '',
          }
        ],
        'specialInstructions': 'Test special instructions',
        'images': [],
        'status': 'pending',
        'riderId': null,
        'riderName': null,
        'paymentMethod': 'cashOnDelivery',
        'totalAmount': 100.0,
        'deliveryFee': 50.0,
        'createdAt': FieldValue.serverTimestamp(),
        'acceptedAt': null,
        'pickedUpAt': null,
        'deliveredAt': null,
        'metadata': null,
      };

      await firestore.collection('orders').doc('test_order_123').set(testOrder);
      print('✅ Test order created successfully!');
    } catch (e) {
      print('❌ Error creating test order: $e');
    }
  }
}
