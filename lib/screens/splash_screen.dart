import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../utils/app_theme.dart';
import '../utils/localization.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  void _checkAuthAndNavigate() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    final currentUserAsync = ref.read(currentUserProvider);

    authState.when(
      data: (user) {
        if (user != null) {
          currentUserAsync.when(
            data: (userData) {
              if (userData != null) {
                switch (userData.role) {
                  case UserRole.customer:
                    context.go('/customer/home');
                    break;
                  case UserRole.rider:
                    context.go('/rider/home');
                    break;
                  case UserRole.admin:
                    context.go('/admin/dashboard');
                    break;
                }
              } else {
                context.go('/auth/login');
              }
            },
            loading: () {
              // Wait a bit more for user data to load
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) context.go('/auth/login');
              });
            },
            error: (_, __) => context.go('/auth/login'),
          );
        } else {
          context.go('/auth/login');
        }
      },
      loading: () {
        // Wait a bit more for auth state to load
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) context.go('/auth/login');
        });
      },
      error: (_, __) => context.go('/auth/login'),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo with animations
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          size: 60,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // App Name
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  localizations?.appName ?? 'Local Express',
                  style: AppTheme.headingLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Fast & Reliable Delivery in Vehari',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 48),

              // Loading Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 120,
                  height: 6,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white30,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Loading Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  localizations?.loading ?? 'Loading...',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
