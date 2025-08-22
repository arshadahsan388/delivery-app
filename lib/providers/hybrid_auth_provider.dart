import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

// Hybrid auth state for both Firebase and local admin
class HybridAuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool isFirebaseUser;

  const HybridAuthState({
    this.isLoading = false,
    this.user,
    this.error,
    this.isFirebaseUser = false,
  });

  HybridAuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? isFirebaseUser,
  }) {
    return HybridAuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isFirebaseUser: isFirebaseUser ?? this.isFirebaseUser,
    );
  }
}

// Provider for hybrid authentication
final hybridAuthProvider = StateNotifierProvider<HybridAuthNotifier, HybridAuthState>((ref) {
  return HybridAuthNotifier();
});

class HybridAuthNotifier extends StateNotifier<HybridAuthState> {
  HybridAuthNotifier() : super(const HybridAuthState()) {
    _initializeAuth();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Admin credentials (only you can use these)
  static const String adminEmail = 'admin@localexpress.com';
  static const String adminPassword = 'admin123';

  void _initializeAuth() {
    // Check current user immediately first
    _checkCurrentUser();
    
    // Then listen to Firebase auth state changes
    _firebaseAuth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        // Firebase user is logged in
        final userModel = _createUserModelFromFirebase(firebaseUser);
        state = state.copyWith(user: userModel, isFirebaseUser: true);
      } else {
        // No Firebase user, check if admin was logged in locally
        if (state.user?.role != UserRole.admin) {
          state = state.copyWith(user: null, isFirebaseUser: false);
        }
      }
    });
  }

  void _checkCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      // Firebase user is logged in
      final userModel = _createUserModelFromFirebase(firebaseUser);
      state = state.copyWith(user: userModel, isFirebaseUser: true);
    }
  }

  // Public method to force check current user
  Future<void> checkCurrentUser() async {
    _checkCurrentUser();
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Check if it's admin login
      if (email.toLowerCase() == adminEmail && password == adminPassword) {
        await Future.delayed(const Duration(milliseconds: 500));
        final adminUser = UserModel(
          id: 'admin-local-express',
          name: 'Admin Manager',
          email: adminEmail,
          role: UserRole.admin,
          createdAt: DateTime.now(),
          isActive: true,
        );
        state = state.copyWith(
          isLoading: false, 
          user: adminUser, 
          isFirebaseUser: false
        );
        return;
      }

      // For customers, use Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userModel = _createUserModelFromFirebase(userCredential.user!);
        state = state.copyWith(
          isLoading: false, 
          user: userModel, 
          isFirebaseUser: true
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Try again later';
          break;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Login failed. Please try again.'
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Only customers can signup via Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Update display name
        await userCredential.user!.updateDisplayName(name);
        
        final userModel = _createUserModelFromFirebase(userCredential.user!, customName: name);
        state = state.copyWith(
          isLoading: false, 
          user: userModel, 
          isFirebaseUser: true
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Signup failed';
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Signup failed. Please try again.'
      );
    }
  }

  Future<void> logout() async {
    try {
      if (state.isFirebaseUser) {
        // Firebase logout for customers
        await _firebaseAuth.signOut();
      }
      
      // Clear state completely immediately
      state = const HybridAuthState(
        isLoading: false,
        user: null,
        error: null,
        isFirebaseUser: false,
      );
    } catch (e) {
      // If error occurs, stop loading and show error
      state = state.copyWith(
        isLoading: false, 
        error: 'Failed to sign out.',
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Only Firebase users can reset password
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password reset failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Password reset failed. Please try again.'
      );
    }
  }

  UserModel _createUserModelFromFirebase(User firebaseUser, {String? customName}) {
    return UserModel(
      id: firebaseUser.uid,
      name: customName ?? firebaseUser.displayName ?? 'Customer User',
      email: firebaseUser.email ?? '',
      role: UserRole.customer, // All Firebase users are customers
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      isActive: true,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
