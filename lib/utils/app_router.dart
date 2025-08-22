import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/customer/home_screen.dart';
import '../screens/customer/shops_screen.dart';
import '../screens/customer/order_form_screen.dart';
import '../screens/customer/order_history_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/rider/rider_home_screen.dart';
import '../screens/rider/rider_orders_screen.dart';
import '../screens/rider/order_details_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_orders_screen.dart';
import '../screens/admin/admin_shops_screen.dart';
import '../screens/admin/admin_riders_screen.dart';
import '../screens/splash_screen.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final userData = currentUser.maybeWhen(
        data: (user) => user,
        orElse: () => null,
      );

      // If on splash screen, let it handle the navigation
      if (state.fullPath == '/splash') {
        return null;
      }

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && 
          !state.fullPath!.startsWith('/auth/')) {
        return '/auth/login';
      }

      // If authenticated but trying to access auth routes
      if (isAuthenticated && state.fullPath!.startsWith('/auth/')) {
        if (userData != null) {
          switch (userData.role) {
            case UserRole.customer:
              return '/customer/home';
            case UserRole.rider:
              return '/rider/home';
            case UserRole.admin:
              return '/admin/dashboard';
          }
        }
        return '/customer/home'; // Default fallback
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Customer Routes
      GoRoute(
        path: '/customer/home',
        name: 'customer-home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/customer/shops',
        name: 'shops',
        builder: (context, state) => const ShopsScreen(),
      ),
      GoRoute(
        path: '/customer/order/:shopId',
        name: 'order-form',
        builder: (context, state) => OrderFormScreen(
          shopId: state.pathParameters['shopId']!,
        ),
      ),
      GoRoute(
        path: '/customer/orders',
        name: 'order-history',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        name: 'customer-profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Rider Routes
      GoRoute(
        path: '/rider/home',
        name: 'rider-home',
        builder: (context, state) => const RiderHomeScreen(),
      ),
      GoRoute(
        path: '/rider/orders',
        name: 'rider-orders',
        builder: (context, state) => const RiderOrdersScreen(),
      ),
      GoRoute(
        path: '/rider/order/:orderId',
        name: 'order-details',
        builder: (context, state) => OrderDetailsScreen(
          orderId: state.pathParameters['orderId']!,
        ),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/orders',
        name: 'admin-orders',
        builder: (context, state) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: '/admin/shops',
        name: 'admin-shops',
        builder: (context, state) => const AdminShopsScreen(),
      ),
      GoRoute(
        path: '/admin/riders',
        name: 'admin-riders',
        builder: (context, state) => const AdminRidersScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you\'re looking for doesn\'t exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
