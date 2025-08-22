import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

// Firebase auth state
class FirebaseAuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const FirebaseAuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  FirebaseAuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return FirebaseAuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Firebase auth provider
final firebaseAuthProvider = StateNotifierProvider<FirebaseAuthNotifier, FirebaseAuthState>((ref) {
  return FirebaseAuthNotifier();
});

class FirebaseAuthNotifier extends StateNotifier<FirebaseAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuthNotifier() : super(const FirebaseAuthState()) {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in
        final userModel = _createUserModel(user);
        state = state.copyWith(user: userModel, isLoading: false);
      } else {
        // User is signed out
        state = const FirebaseAuthState();
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        final userModel = _createUserModel(result.user!);
        state = state.copyWith(isLoading: false, user: userModel);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'Email is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'User account has been disabled.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong. Please try again.');
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        // Update display name
        await result.user!.updateDisplayName(name);
        
        final userModel = _createUserModel(result.user!, customName: name);
        state = state.copyWith(isLoading: false, user: userModel);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Email is not valid.';
          break;
        default:
          errorMessage = 'Signup failed. Please try again.';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      await _auth.signOut();
      // State will be updated automatically by authStateChanges listener
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to sign out.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Email is not valid.';
          break;
        default:
          errorMessage = 'Failed to send reset email.';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  UserModel _createUserModel(User user, {String? customName}) {
    // Determine user role based on email pattern
    UserRole userRole;
    String userName;
    
    final email = user.email ?? '';
    
    if (email.toLowerCase().contains('admin') || email.toLowerCase().contains('manager')) {
      userRole = UserRole.admin;
      userName = customName ?? user.displayName ?? 'Admin Manager';
    } else if (email.toLowerCase().contains('rider') || email.toLowerCase().contains('driver')) {
      userRole = UserRole.rider;
      userName = customName ?? user.displayName ?? 'Delivery Rider';
    } else {
      userRole = UserRole.customer;
      userName = customName ?? user.displayName ?? 'Customer User';
    }
    
    return UserModel(
      id: user.uid,
      name: userName,
      email: email,
      role: userRole,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      isActive: !user.disabled,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
