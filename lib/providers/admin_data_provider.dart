import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/shop_model.dart';

class AdminData {
  final List<CategoryModel> categories;
  final List<ShopModel> shops;
  final bool isLoading;
  final String? error;

  AdminData({
    required this.categories,
    required this.shops,
    this.isLoading = false,
    this.error,
  });

  AdminData copyWith({
    List<CategoryModel>? categories,
    List<ShopModel>? shops,
    bool? isLoading,
    String? error,
  }) {
    return AdminData(
      categories: categories ?? this.categories,
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AdminDataNotifier extends StateNotifier<AdminData> {
  AdminDataNotifier() : super(AdminData(
    categories: [],
    shops: [],
    isLoading: true,
  )) {
    _loadDataFromFirebase();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Load categories and shops from Firebase
  Future<void> _loadDataFromFirebase() async {
    try {
      print('AdminDataProvider: Loading data from Firebase...');
      
      // Load categories
      final categoriesSnapshot = await _firestore.collection('categories').get();
      final categories = categoriesSnapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Load shops
      final shopsSnapshot = await _firestore.collection('shops').get();
      final shops = shopsSnapshot.docs
          .map((doc) => ShopModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      print('AdminDataProvider: Loaded ${categories.length} categories and ${shops.length} shops');
      
      state = state.copyWith(
        categories: categories,
        shops: shops,
        isLoading: false,
      );
    } catch (e) {
      print('AdminDataProvider: Error loading data: $e');
      state = state.copyWith(
        categories: _defaultCategories,
        shops: _defaultShops,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Add Category to Firebase
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').doc(category.id).set(category.toJson());
      
      state = state.copyWith(
        categories: [...state.categories, category],
      );
      print('AdminDataProvider: Added category ${category.name}');
    } catch (e) {
      print('AdminDataProvider: Error adding category: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // Delete Category from Firebase
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
      
      // Also delete shops in this category
      final shopsToDelete = state.shops.where((shop) => shop.categories.contains(categoryId));
      for (final shop in shopsToDelete) {
        await _firestore.collection('shops').doc(shop.id).delete();
      }
      
      state = state.copyWith(
        categories: state.categories.where((cat) => cat.id != categoryId).toList(),
        shops: state.shops.where((shop) => !shop.categories.contains(categoryId)).toList(),
      );
      print('AdminDataProvider: Deleted category $categoryId');
    } catch (e) {
      print('AdminDataProvider: Error deleting category: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // Add Shop to Firebase
  Future<void> addShop(ShopModel shop) async {
    try {
      await _firestore.collection('shops').doc(shop.id).set(shop.toJson());
      
      state = state.copyWith(
        shops: [...state.shops, shop],
      );
      print('AdminDataProvider: Added shop ${shop.name}');
    } catch (e) {
      print('AdminDataProvider: Error adding shop: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // Delete Shop from Firebase
  Future<void> deleteShop(String shopId) async {
    try {
      await _firestore.collection('shops').doc(shopId).delete();
      
      state = state.copyWith(
        shops: state.shops.where((shop) => shop.id != shopId).toList(),
      );
      print('AdminDataProvider: Deleted shop $shopId');
    } catch (e) {
      print('AdminDataProvider: Error deleting shop: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // Update Shop Status
  void toggleShopStatus(String shopId) {
    final updatedShops = state.shops.map((shop) {
      if (shop.id == shopId) {
        return ShopModel(
          id: shop.id,
          name: shop.name,
          description: shop.description,
          logo: shop.logo,
          coverImage: shop.coverImage,
          address: shop.address,
          latitude: shop.latitude,
          longitude: shop.longitude,
          phone: shop.phone,
          email: shop.email,
          categories: shop.categories,
          isActive: !shop.isActive,
          openingHours: shop.openingHours,
          rating: shop.rating,
          totalOrders: shop.totalOrders,
          createdAt: shop.createdAt,
          ownerId: shop.ownerId,
        );
      }
      return shop;
    }).toList();

    state = state.copyWith(shops: updatedShops);
  }
}

// Provider
final adminDataProvider = StateNotifierProvider<AdminDataNotifier, AdminData>((ref) {
  return AdminDataNotifier();
});

// Default Categories
final List<CategoryModel> _defaultCategories = [
  CategoryModel(
    id: '1',
    name: 'Fast Food',
    description: 'Quick and delicious fast food options',
    icon: Icons.fastfood,
    color: const Color(0xFFFF6B6B),
    createdAt: DateTime.now(),
    isActive: true,
  ),
  CategoryModel(
    id: '2',
    name: 'Pizza',
    description: 'Hot and fresh pizza varieties',
    icon: Icons.local_pizza,
    color: const Color(0xFF4ECDC4),
    createdAt: DateTime.now(),
    isActive: true,
  ),
  ),
  CategoryModel(
    id: '3',
    name: 'Desi Food',
    description: 'Traditional Pakistani cuisine',
    icon: Icons.restaurant,
    color: const Color(0xFF45B7D1),
    createdAt: DateTime.now(),
  ),
  CategoryModel(
    id: '4',
    name: 'Chinese',
    description: 'Authentic Chinese dishes',
    icon: Icons.ramen_dining,
    color: const Color(0xFF96CEB4),
    createdAt: DateTime.now(),
  ),
  CategoryModel(
    id: '5',
    name: 'Sweets',
    description: 'Desserts and sweet treats',
    icon: Icons.cake,
    color: const Color(0xFFFECEA8),
    createdAt: DateTime.now(),
  ),
  CategoryModel(
    id: '6',
    name: 'Drinks',
    description: 'Refreshing beverages and drinks',
    icon: Icons.local_drink,
    color: const Color(0xFFFF9FF3),
    createdAt: DateTime.now(),
  ),
];

// Default Shops
final List<ShopModel> _defaultShops = [
  ShopModel(
    id: '1',
    name: 'McDonald\'s',
    description: 'I\'m lovin\' it - World famous burgers and fries',
    logo: 'https://via.placeholder.com/100',
    address: 'Main Bazaar, Vehari',
    latitude: 30.0457,
    longitude: 72.3489,
    phone: '042-123456789',
    email: 'mcdonalds@vehari.com',
    categories: ['1'], // Fast Food
    isActive: true,
    openingHours: {'open': '10:00', 'close': '23:00'},
    rating: 4.5,
    totalOrders: 1250,
    createdAt: DateTime.now(),
    ownerId: 'owner1',
  ),
  ShopModel(
    id: '2',
    name: 'Pizza Hut',
    description: 'Hot and fresh pizza delivered fast',
    logo: 'https://via.placeholder.com/100',
    address: 'Commercial Area, Vehari',
    latitude: 30.0467,
    longitude: 72.3499,
    phone: '042-987654321',
    email: 'pizzahut@vehari.com',
    categories: ['2'], // Pizza
    isActive: true,
    openingHours: {'open': '12:00', 'close': '24:00'},
    rating: 4.2,
    totalOrders: 890,
    createdAt: DateTime.now(),
    ownerId: 'owner2',
  ),
  ShopModel(
    id: '3',
    name: 'Desi Dhaba',
    description: 'Authentic Pakistani food with traditional taste',
    logo: 'https://via.placeholder.com/100',
    address: 'Old City, Vehari',
    latitude: 30.0447,
    longitude: 72.3479,
    phone: '042-555666777',
    email: 'desidhaba@vehari.com',
    categories: ['3'], // Desi Food
    isActive: true,
    openingHours: {'open': '11:00', 'close': '23:30'},
    rating: 4.7,
    totalOrders: 2100,
    createdAt: DateTime.now(),
    ownerId: 'owner3',
  ),
  ShopModel(
    id: '4',
    name: 'China Town',
    description: 'Best Chinese cuisine in Vehari',
    logo: 'https://via.placeholder.com/100',
    address: 'City Center, Vehari',
    latitude: 30.0477,
    longitude: 72.3509,
    phone: '042-111222333',
    email: 'chinatown@vehari.com',
    categories: ['4'], // Chinese
    isActive: true,
    openingHours: {'open': '13:00', 'close': '22:00'},
    rating: 4.0,
    totalOrders: 567,
    createdAt: DateTime.now(),
    ownerId: 'owner4',
  ),
  ShopModel(
    id: '5',
    name: 'Sweet Palace',
    description: 'Traditional sweets and modern desserts',
    logo: 'https://via.placeholder.com/100',
    address: 'Sweets Market, Vehari',
    latitude: 30.0437,
    longitude: 72.3469,
    phone: '042-444555666',
    email: 'sweetpalace@vehari.com',
    categories: ['5'], // Sweets
    isActive: true,
    openingHours: {'open': '09:00', 'close': '22:00'},
    rating: 4.3,
    totalOrders: 1456,
    createdAt: DateTime.now(),
    ownerId: 'owner5',
  ),
];
