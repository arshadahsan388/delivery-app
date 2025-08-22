class Product {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String category;
  final bool isAvailable;
  final int stock;
  final List<String> tags;
  final Map<String, dynamic>? variants; // size, color, etc.
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.category,
    required this.isAvailable,
    required this.stock,
    required this.tags,
    this.variants,
    required this.rating,
    required this.reviewCount,
    required this.isFeatured,
    required this.createdAt,
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return 0.0;
  }

  // Check if product is on sale
  bool get isOnSale => originalPrice != null && originalPrice! > price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      shopId: json['shopId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      stock: json['stock'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      variants: json['variants'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'isAvailable': isAvailable,
      'stock': stock,
      'tags': tags,
      'variants': variants,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
