import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String? coverImage;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String? email;
  final List<String> categories;
  final bool isActive;
  final Map<String, dynamic> openingHours;
  final double rating;
  final int totalOrders;
  final DateTime createdAt;
  final String ownerId;

  ShopModel({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    this.coverImage,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    this.email,
    this.categories = const [],
    this.isActive = true,
    this.openingHours = const {},
    this.rating = 0.0,
    this.totalOrders = 0,
    required this.createdAt,
    required this.ownerId,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'],
      coverImage: json['coverImage'],
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      phone: json['phone'] ?? '',
      email: json['email'],
      categories: List<String>.from(json['categories'] ?? []),
      isActive: json['isActive'] ?? true,
      openingHours: Map<String, dynamic>.from(json['openingHours'] ?? {}),
      rating: json['rating']?.toDouble() ?? 0.0,
      totalOrders: json['totalOrders'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ownerId: json['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'coverImage': coverImage,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'email': email,
      'categories': categories,
      'isActive': isActive,
      'openingHours': openingHours,
      'rating': rating,
      'totalOrders': totalOrders,
      'createdAt': Timestamp.fromDate(createdAt),
      'ownerId': ownerId,
    };
  }

  ShopModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    String? coverImage,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    List<String>? categories,
    bool? isActive,
    Map<String, dynamic>? openingHours,
    double? rating,
    int? totalOrders,
    DateTime? createdAt,
    String? ownerId,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      categories: categories ?? this.categories,
      isActive: isActive ?? this.isActive,
      openingHours: openingHours ?? this.openingHours,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
