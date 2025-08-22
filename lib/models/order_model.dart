import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  pickedUp,
  onTheWay,
  delivered,
  cancelled
}

enum PaymentMethod { cashOnDelivery, easypaisa, jazzcash, card }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double customerLatitude;
  final double customerLongitude;
  final String shopId;
  final String shopName;
  final String shopAddress;
  final List<OrderItem> items;
  final String? specialInstructions;
  final List<String>? images;
  final OrderStatus status;
  final String? riderId;
  final String? riderName;
  final PaymentMethod paymentMethod;
  final double totalAmount;
  final double deliveryFee;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final Map<String, dynamic>? metadata;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.shopId,
    required this.shopName,
    required this.shopAddress,
    required this.items,
    this.specialInstructions,
    this.images,
    this.status = OrderStatus.pending,
    this.riderId,
    this.riderName,
    this.paymentMethod = PaymentMethod.cashOnDelivery,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.metadata,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      customerLatitude: json['customerLatitude']?.toDouble() ?? 0.0,
      customerLongitude: json['customerLongitude']?.toDouble() ?? 0.0,
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
      items: (json['items'] as List?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      specialInstructions: json['specialInstructions'],
      images: List<String>.from(json['images'] ?? []),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      riderId: json['riderId'],
      riderName: json['riderName'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
        orElse: () => PaymentMethod.cashOnDelivery,
      ),
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
      createdAt: _parseDateTime(json['createdAt']),
      acceptedAt: _parseDateTimeOptional(json['acceptedAt']),
      pickedUpAt: _parseDateTimeOptional(json['pickedUpAt']),
      deliveredAt: _parseDateTimeOptional(json['deliveredAt']),
      metadata: json['metadata'],
    );
  }

  // Helper method to parse DateTime from various formats
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date string: $value, error: $e');
        return DateTime.now();
      }
    } else if (value is DateTime) {
      return value;
    }
    
    print('Unknown date format: $value (${value.runtimeType})');
    return DateTime.now();
  }

  // Helper method for optional DateTime fields
  static DateTime? _parseDateTimeOptional(dynamic value) {
    if (value == null) return null;
    
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing optional date string: $value, error: $e');
        return null;
      }
    } else if (value is DateTime) {
      return value;
    }
    
    print('Unknown optional date format: $value (${value.runtimeType})');
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerLatitude': customerLatitude,
      'customerLongitude': customerLongitude,
      'shopId': shopId,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'specialInstructions': specialInstructions,
      'images': images,
      'status': status.toString().split('.').last,
      'riderId': riderId,
      'riderName': riderName,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'pickedUpAt': pickedUpAt != null ? Timestamp.fromDate(pickedUpAt!) : null,
      'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'metadata': metadata,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    double? customerLatitude,
    double? customerLongitude,
    String? shopId,
    String? shopName,
    String? shopAddress,
    List<OrderItem>? items,
    String? specialInstructions,
    List<String>? images,
    OrderStatus? status,
    String? riderId,
    String? riderName,
    PaymentMethod? paymentMethod,
    double? totalAmount,
    double? deliveryFee,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
      items: items ?? this.items,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      images: images ?? this.images,
      status: status ?? this.status,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class OrderItem {
  final String name;
  final String? description;
  final int quantity;
  final double price;
  final String? notes;

  OrderItem({
    required this.name,
    this.description,
    required this.quantity,
    required this.price,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? '',
      description: json['description'],
      quantity: json['quantity'] ?? 1,
      price: json['price']?.toDouble() ?? 0.0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'notes': notes,
    };
  }

  OrderItem copyWith({
    String? name,
    String? description,
    int? quantity,
    double? price,
    String? notes,
  }) {
    return OrderItem(
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}
