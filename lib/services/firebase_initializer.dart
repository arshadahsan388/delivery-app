import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Automatically create all necessary collections and sample data
  static Future<void> initializeFirebaseData() async {
    try {
      print('🔥 Starting Firebase initialization...');
      
      // Create Categories Collection
      await _createCategories();
      
      // Create Shops Collection  
      await _createShops();
      
      // Create Products Collection
      await _createProducts();
      
      // Setup Firestore Rules (will show in console)
      await _setupFirestoreRules();
      
      print('✅ Firebase initialization completed successfully!');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
    }
  }
  
  static Future<void> _createCategories() async {
    final categories = [
      {
        'id': 'food',
        'name': 'Food & Restaurants',
        'nameUrdu': 'کھانا اور ریسٹورنٹس',
        'icon': 'restaurant',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'grocery',
        'name': 'Grocery & Essentials',
        'nameUrdu': 'گروسری اور ضروریات',
        'icon': 'shopping_cart',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'pharmacy',
        'name': 'Pharmacy & Health',
        'nameUrdu': 'فارمیسی اور صحت',
        'icon': 'local_pharmacy',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'electronics',
        'name': 'Electronics',
        'nameUrdu': 'الیکٹرانکس',
        'icon': 'devices',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];
    
    for (var category in categories) {
      await _firestore.collection('categories').doc(category['id'] as String).set(category);
      print('📁 Created category: ${category['name']}');
    }
  }
  
  static Future<void> _createShops() async {
    final shops = [
      {
        'id': 'vehari-restaurant',
        'name': 'Vehari Famous Restaurant',
        'nameUrdu': 'وہاڑی مشہور ریسٹورنٹ',
        'category': 'food',
        'address': 'Main Bazaar, Vehari',
        'phone': '+92-300-1234567',
        'rating': 4.5,
        'deliveryTime': '30-45 mins',
        'deliveryFee': 50.0,
        'isActive': true,
        'location': {
          'latitude': 30.0386,
          'longitude': 72.3497,
        },
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'al-barkat-grocery',
        'name': 'Al-Barkat Grocery Store',
        'nameUrdu': 'البرکت گروسری سٹور',
        'category': 'grocery',
        'address': 'Chowk Azam, Vehari',
        'phone': '+92-300-9876543',
        'rating': 4.2,
        'deliveryTime': '20-30 mins',
        'deliveryFee': 30.0,
        'isActive': true,
        'location': {
          'latitude': 30.0450,
          'longitude': 72.3550,
        },
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'city-pharmacy',
        'name': 'City Pharmacy Vehari',
        'nameUrdu': 'سٹی فارمیسی وہاڑی',
        'category': 'pharmacy',
        'address': 'Hospital Road, Vehari',
        'phone': '+92-300-5555555',
        'rating': 4.7,
        'deliveryTime': '15-25 mins',
        'deliveryFee': 25.0,
        'isActive': true,
        'location': {
          'latitude': 30.0400,
          'longitude': 72.3480,
        },
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];
    
    for (var shop in shops) {
      await _firestore.collection('shops').doc(shop['id'] as String).set(shop);
      print('🏪 Created shop: ${shop['name']}');
    }
  }
  
  static Future<void> _createProducts() async {
    final products = [
      // Restaurant Products
      {
        'id': 'biryani-special',
        'shopId': 'vehari-restaurant',
        'name': 'Special Chicken Biryani',
        'nameUrdu': 'خصوصی چکن بریانی',
        'description': 'Delicious aromatic biryani with tender chicken',
        'price': 350.0,
        'category': 'food',
        'isAvailable': true,
        'imageUrl': 'https://example.com/biryani.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'karahi-chicken',
        'shopId': 'vehari-restaurant',
        'name': 'Chicken Karahi',
        'nameUrdu': 'چکن کڑاہی',
        'description': 'Traditional Pakistani chicken curry',
        'price': 800.0,
        'category': 'food',
        'isAvailable': true,
        'imageUrl': 'https://example.com/karahi.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      },
      
      // Grocery Products
      {
        'id': 'rice-basmati',
        'shopId': 'al-barkat-grocery',
        'name': 'Basmati Rice (5kg)',
        'nameUrdu': 'بسماتی چاول (5 کلو)',
        'description': 'Premium quality basmati rice',
        'price': 1200.0,
        'category': 'grocery',
        'isAvailable': true,
        'imageUrl': 'https://example.com/rice.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'id': 'oil-cooking',
        'shopId': 'al-barkat-grocery',
        'name': 'Cooking Oil (1L)',
        'nameUrdu': 'کھانا پکانے کا تیل (1 لیٹر)',
        'description': 'Pure cooking oil',
        'price': 400.0,
        'category': 'grocery',
        'isAvailable': true,
        'imageUrl': 'https://example.com/oil.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      },
      
      // Pharmacy Products
      {
        'id': 'panadol-tablets',
        'shopId': 'city-pharmacy',
        'name': 'Panadol (Pack of 20)',
        'nameUrdu': 'پینادول (20 کی پیک)',
        'description': 'Pain relief tablets',
        'price': 85.0,
        'category': 'pharmacy',
        'isAvailable': true,
        'imageUrl': 'https://example.com/panadol.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];
    
    for (var product in products) {
      await _firestore.collection('products').doc(product['id'] as String).set(product);
      print('📦 Created product: ${product['name']}');
    }
  }
  
  static Future<void> _setupFirestoreRules() async {
    print('''
🔒 Copy these Firestore Rules to Firebase Console:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Categories are readable by everyone
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Shops are readable by everyone
    match /shops/{shopId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Products are readable by everyone
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Orders can be read/written by everyone (for demo purposes)
    // In production, you should implement proper authentication
    match /orders/{orderId} {
      allow read, write: if true;
    }
    
    // Custom orders
    match /customOrders/{orderId} {
      allow read, write: if true;
    }
  }
}
    ''');
  }
}
