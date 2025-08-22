import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoriesState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  CategoriesNotifier() : super(const CategoriesState(isLoading: true)) {
    _listenToCategories();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listen to real-time category updates from Firebase
  void _listenToCategories() {
    print('CategoriesProvider: Starting to listen to categories...');
    _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      try {
        print('CategoriesProvider: Received ${snapshot.docs.length} categories');
        final categories = snapshot.docs
            .map((doc) {
              print('CategoriesProvider: Processing category ${doc.id}');
              return CategoryModel.fromJson({...doc.data(), 'id': doc.id});
            })
            .toList();

        print('CategoriesProvider: Successfully parsed ${categories.length} categories');
        state = state.copyWith(categories: categories, isLoading: false, error: null);
      } catch (e) {
        print('CategoriesProvider: Error parsing categories: $e');
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }, onError: (error) {
      print('CategoriesProvider: Snapshot error: $error');
      state = state.copyWith(error: error.toString(), isLoading: false);
    });
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider for customer categories
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  return CategoriesNotifier();
});
