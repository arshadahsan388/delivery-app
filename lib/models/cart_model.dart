import 'product_model.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  final Map<String, dynamic>? selectedVariants;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedVariants,
    this.specialInstructions,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    Map<String, dynamic>? selectedVariants,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
      selectedVariants: json['selectedVariants'],
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'selectedVariants': selectedVariants,
      'specialInstructions': specialInstructions,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final String? couponCode;
  final double couponDiscount;
  final double deliveryFee;

  Cart({
    required this.items,
    this.couponCode,
    this.couponDiscount = 0.0,
    this.deliveryFee = 0.0,
  });

  // Calculate subtotal (items total without delivery fee)
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate total items count
  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Calculate final total
  double get total {
    return subtotal - couponDiscount + deliveryFee;
  }

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  // Get items grouped by shop
  Map<String, List<CartItem>> get itemsByShop {
    final Map<String, List<CartItem>> grouped = {};
    for (final item in items) {
      final shopId = item.product.shopId;
      if (!grouped.containsKey(shopId)) {
        grouped[shopId] = [];
      }
      grouped[shopId]!.add(item);
    }
    return grouped;
  }

  Cart copyWith({
    List<CartItem>? items,
    String? couponCode,
    double? couponDiscount,
    double? deliveryFee,
  }) {
    return Cart(
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List? ?? [])
          .map((item) => CartItem.fromJson(item))
          .toList(),
      couponCode: json['couponCode'],
      couponDiscount: (json['couponDiscount'] ?? 0.0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'couponCode': couponCode,
      'couponDiscount': couponDiscount,
      'deliveryFee': deliveryFee,
    };
  }
}
