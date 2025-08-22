enum CustomOrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class CustomOrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String deliveryAddress;
  final String customOrder;
  final String? specialInstructions;
  final CustomOrderStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? deliveredAt;
  final String? riderId;
  final String? riderName;
  final double? estimatedPrice;
  final double? finalPrice;
  final String? adminNotes;

  const CustomOrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.customOrder,
    this.specialInstructions,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.deliveredAt,
    this.riderId,
    this.riderName,
    this.estimatedPrice,
    this.finalPrice,
    this.adminNotes,
  });

  CustomOrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? deliveryAddress,
    String? customOrder,
    String? specialInstructions,
    CustomOrderStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? deliveredAt,
    String? riderId,
    String? riderName,
    double? estimatedPrice,
    double? finalPrice,
    String? adminNotes,
  }) {
    return CustomOrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customOrder: customOrder ?? this.customOrder,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      adminNotes: adminNotes ?? this.adminNotes,
    );
  }

  String get statusText {
    switch (status) {
      case CustomOrderStatus.pending:
        return 'Pending Review';
      case CustomOrderStatus.confirmed:
        return 'Confirmed';
      case CustomOrderStatus.preparing:
        return 'Preparing';
      case CustomOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case CustomOrderStatus.delivered:
        return 'Delivered';
      case CustomOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusEmoji {
    switch (status) {
      case CustomOrderStatus.pending:
        return '⏳';
      case CustomOrderStatus.confirmed:
        return '✅';
      case CustomOrderStatus.preparing:
        return '👨‍🍳';
      case CustomOrderStatus.outForDelivery:
        return '🚗';
      case CustomOrderStatus.delivered:
        return '🎉';
      case CustomOrderStatus.cancelled:
        return '❌';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'customOrder': customOrder,
      'specialInstructions': specialInstructions,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'riderId': riderId,
      'riderName': riderName,
      'estimatedPrice': estimatedPrice,
      'finalPrice': finalPrice,
      'adminNotes': adminNotes,
    };
  }

  factory CustomOrderModel.fromJson(Map<String, dynamic> json) {
    return CustomOrderModel(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      deliveryAddress: json['deliveryAddress'],
      customOrder: json['customOrder'],
      specialInstructions: json['specialInstructions'],
      status: CustomOrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CustomOrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      confirmedAt: json['confirmedAt'] != null 
          ? DateTime.parse(json['confirmedAt']) 
          : null,
      deliveredAt: json['deliveredAt'] != null 
          ? DateTime.parse(json['deliveredAt']) 
          : null,
      riderId: json['riderId'],
      riderName: json['riderName'],
      estimatedPrice: json['estimatedPrice']?.toDouble(),
      finalPrice: json['finalPrice']?.toDouble(),
      adminNotes: json['adminNotes'],
    );
  }
}
